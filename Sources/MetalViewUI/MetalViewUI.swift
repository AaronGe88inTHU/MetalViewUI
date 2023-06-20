import SwiftUI
import MetalKit
import Combine

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

#if os(macOS)
/// `MetalViewUI` is a struct that wraps an `MTKView` and manages its rendering behavior for SwiftUI .
///
/// It holds references to a `MTLDevice` and a `MTKViewDelegate` that are used for configuring the `MTKView`. The `MetalViewUI` class also defines a `SetNeedsDisplayTrigger` typealias which is used to define publishers that can trigger redraws of the `MTKView`.
public struct MetalViewUI: NSViewRepresentable{
    
    /// A publisher that emits notifications to trigger redraws of the `MTKView`. It doesn't emit any values and never fails.
    public typealias SetNeedsDisplayTrigger = AnyPublisher<Void, Never>

    /// The type of view that `MetalViewUI` manages, which is an `MTKView`.
    public typealias NSViewType = MTKView
    
    /// A `MTLDevice` instance used to create and configure the `MTKView`.
    /// This property may be `nil`, in which case the `MTKView` uses the default device.
    private let metalDevice: MTLDevice?
    
    /// An `MTKViewDelegate` that manages the rendering behavior of the `MTKView`.
    /// This property is a weak reference to prevent retain cycles. It may be `nil`, in which case the `MTKView` has no delegate.
    private weak var renderer: MTKViewDelegate?
    
    
    /// Initializes a new `MetalViewUI` with the provided parameters.
    ///
    /// This initializer creates a `MetalViewUI` with a specified `DrawingMode` and `Coordinator`.
    ///
    /// - Parameters:
    ///   - metalDevice: A `MTLDevice` to use for creating and configuring the `MTKView`. If this parameter is `nil`, the `MTKView` uses the default device.
    ///   - renderer: An `MTKViewDelegate` that manages the rendering behavior of the `MTKView`. If this parameter is `nil`, the `MTKView` has no delegate.
    public init(metalDevice: MTLDevice?, renderer: MTKViewDelegate?) {
        
        self.metalDevice = metalDevice
        self.renderer = renderer
        
    }
    
    
    /// Creates a Coordinator instance for the view
    ///
    /// This method creates a ``Coordinator`` instance that can manage and coordinate tasks for the view. The coordinator can handle user interactions, manage complex updates, or coordinate with other system services on behalf of the view.
    ///
    /// - Returns: A new `Coordinator` instance.
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    /// Defines the drawing modes for the `MTKView` in the `MetalViewUI`.
    ///
    /// This enum provides two modes of operation for redrawing the `MTKView`:
    /// * `timeUpdates`: The view updates at a regular interval specified by `preferredFramesPerSecond`.
    /// * `drawNotifications`: The view updates in response to notifications from a `SetNeedsDisplayTrigger`.
    public enum DrawingMode {
        /// A drawing mode where the `MTKView` updates at a regular interval.
        ///
        /// The view attempts to redraw itself at the rate specified by `preferredFramesPerSecond`. However, the actual frame rate can be lower if the system cannot keep up with this rate.
        ///
        /// - Parameter preferredFramesPerSecond: The preferred frame rate for updates, in frames per second.
        case timeUpdates(preferredFramesPerSecond: Int)
        
        /// A drawing mode where the `MTKView` updates in response to notifications.
        ///
        /// The view redraws itself whenever it receives a notification from the `setNeedsDisplayTrigger`. If this trigger is `nil`, the view does not automatically redraw itself.
        ///
        /// - Parameter setNeedsDisplayTrigger: The trigger that causes the view to redraw itself, or `nil` if there is no such trigger.
        case drawNotifications(setNeedsDisplayTrigger: SetNeedsDisplayTrigger?)
        
    }
    
    /// Creates an NSView instance using the specified context.
    ///
    /// This method creates an `NSView` instance using the provided `context`. The context provides additional information that can be used to configure the view. For example, the context could include style settings, environment configurations, or other custom data.
    ///
    /// - Parameter context: An object that provides information to configure the new view.
    /// - Returns: A new `NSView` instance configured using the provided context.
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView(frame: .zero)
        return mtkView
    }
    
    /// Updates an existing MTKView instance using the specified context.
    ///
    /// This method updates the provided `MTKView` instance using the `context`. The context provides additional information that can be used to reconfigure the view. For example, the context could include style settings, environment configurations, or other custom data.
    ///
    /// - Parameters:
    ///   - nsView: The `MTKView` instance to update.
    ///   - context: An object that provides information to reconfigure the view.
    public func updateNSView(_ nsView: MTKView, context: Context) {
        
    }
    
    
    /// `Coordinator` is a class that manages and coordinates tasks for a view.
    ///
    /// It holds an `MTKView` and a `SetNeedsDisplayTrigger` property that can be used to trigger a redraw of the `MTKView` when necessary. The `Coordinator` can handle interactions, manage complex updates, or coordinate with other system services on behalf of the view.
    public class Coordinator {
        
        private var cancellable: AnyCancellable?
        
        /// An instance of `MTKView` that the `Coordinator` is managing.
        /// This view is initialized with a zero frame.
        public var metalView: MTKView = {
            MTKView(frame: .zero)
        }()
        
        /// A `SetNeedsDisplayTrigger` that can be used to trigger redraws of the `metalView`.
        /// When a new value is assigned to this property, the `Coordinator` sets up a subscription that invokes `setNeedsDisplay(_:)` on the `metalView` whenever the trigger fires.
        public var setNeedsDisplayTrigger: SetNeedsDisplayTrigger? {
            
            didSet {
                
                self.cancellable = self.setNeedsDisplayTrigger?.receive(on: DispatchQueue.main).sink { [weak self] in
                    
                    guard let self = self,
                          self.metalView.isPaused,
                          self.metalView.enableSetNeedsDisplay
                    else { return }
                    
                    self.metalView.setNeedsDisplay(.infinite)
                    
                }
                
            }
            
        }
        
        public init() {
            
            self.cancellable = nil
            self.setNeedsDisplayTrigger = nil
            
        }
        
    }
    
   
    
    
}
#elseif os(iOS)
/// A UIViewRepresentable that host MetaiKit for SwiftUI on IOS
public struct MetalViewUI: UIViewRepresentable {
    
    public typealias SetNeedsDisplayTrigger = AnyPublisher<Void, Never>

    public enum DrawingMode {
        
        case timeUpdates(preferredFramesPerSecond: Int)
        case drawNotifications(setNeedsDisplayTrigger: SetNeedsDisplayTrigger?)
        
    }

    public typealias UIViewType = MTKView
    
    private let metalDevice: MTLDevice?
    private weak var renderer: MTKViewDelegate?
    
    public init(metalDevice: MTLDevice?, renderer: MTKViewDelegate?) {
        
        self.metalDevice = metalDevice
        self.renderer = renderer
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public func makeUIView(context: Context) -> MTKView {
        
        let metalView = context.coordinator.metalView
        metalView.device = self.metalDevice
        metalView.delegate = self.renderer
        metalView.apply(context.environment)
        
        context.coordinator.setNeedsDisplayTrigger = context.environment.setNeedsDisplayTrigger
        
        return metalView
    }
    
    public func updateUIView(_ uiView: MTKView, context: Context) {
        
        context.coordinator.metalView.apply(context.environment)
        context.coordinator.setNeedsDisplayTrigger = context.environment.setNeedsDisplayTrigger
        print("UPDATE VIEW")
    }
    
    public class Coordinator {
        
        private var cancellable: AnyCancellable?
        
        public var metalView: MTKView = {
            MTKView(frame: .zero)
        }()
        
        public var setNeedsDisplayTrigger: SetNeedsDisplayTrigger? {
            
            didSet {
                
                self.cancellable = self.setNeedsDisplayTrigger?.receive(on: DispatchQueue.main).sink { [weak self] in
                    
                    guard let self = self,
                          self.metalView.isPaused,
                          self.metalView.enableSetNeedsDisplay
                    else { return }
                    
                    self.metalView.setNeedsDisplay()
                    
                }
                
            }
            
        }
        
        public init() {
            
            self.cancellable = nil
            self.setNeedsDisplayTrigger = nil
            
        }
        
    }
    
}
#endif
