//
//  File.swift
//  
//
//  Created by Alessandro Toschi on 02/01/22.
//

import SwiftUI
import MetalKit

private struct ColorPixelFormatKey: EnvironmentKey {
    static let defaultValue: MTLPixelFormat = .bgra8Unorm
}

private struct FramebufferOnlyKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

private struct DrawableSizeKey: EnvironmentKey {
    static var defaultValue: CGSize = .zero
}

private struct AutoResizeDrawableKey: EnvironmentKey {
    static var defaultValue: Bool = true
}

private struct ClearColorKey: EnvironmentKey {
    static var defaultValue: MTLClearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
}

private struct PreferredFramesPerSecondKey: EnvironmentKey {
    static var defaultValue: Int = 60
}

private struct IsPausedKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

private struct EnableSetNeedsDisplayKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

private struct PresentWithTransactionKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    
    var colorPixelFormat: MTLPixelFormat {
        get { self[ColorPixelFormatKey.self] }
        set { self[ColorPixelFormatKey.self] = newValue }
    }
    
    var framebufferOnly: Bool {
        get { self[FramebufferOnlyKey.self] }
        set { self[FramebufferOnlyKey.self] = newValue }
    }
    
    var drawableSize: CGSize {
        get { self[DrawableSizeKey.self] }
        set { self[DrawableSizeKey.self] = newValue }
    }
    
    var autoResizeDrawable: Bool {
        get { self[AutoResizeDrawableKey.self] }
        set { self[AutoResizeDrawableKey.self] = newValue }
    }
    
    var clearColor: MTLClearColor {
        get { self[ClearColorKey.self] }
        set { self[ClearColorKey.self] = newValue }
    }
    
    var preferredFramesPerSecond: Int {
        get { self[PreferredFramesPerSecondKey.self] }
        set { self[PreferredFramesPerSecondKey.self] = newValue }
    }
    
    var enableSetNeedsDisplay: Bool {
        get { self[IsPausedKey.self] }
        set { self[IsPausedKey.self] = newValue }
    }
    
    var isPaused: Bool {
        get { self[IsPausedKey.self] }
        set { self[IsPausedKey.self] = newValue }
    }
    
    var presentWithTransaction: Bool {
        get { self[IsPausedKey.self] }
        set { self[IsPausedKey.self] = newValue }
    }
    
}

extension MetalView {
    
    func setEnvironment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: V) -> Self {
        _ = self.environment(keyPath, value)
        return self
    }
    
    func colorPixelFormat(_ value: MTLPixelFormat) -> MetalView {
        self.setEnvironment(\.colorPixelFormat, value)
    }

    func framebufferOnly(_ value: Bool) -> MetalView {
        self.setEnvironment(\.framebufferOnly, value)
    }

    func drawableSize(_ value: CGSize) -> MetalView {
        self.setEnvironment(\.drawableSize, value)
    }

    func autoResizeDrawable(_ value: Bool) -> MetalView {
        self.setEnvironment(\.autoResizeDrawable, value)
    }

    func clearColor(_ value: MTLClearColor) -> MetalView {
        self.setEnvironment(\.clearColor, value)
    }

    func preferredFramesPerSecond(_ value: Int) -> MetalView {
        self.setEnvironment(\.preferredFramesPerSecond, value)
    }

    func isPaused(_ value: Bool) -> MetalView {
        self.setEnvironment(\.isPaused, value)
    }

    func enableSetNeedsDisplay(_ value: Bool) -> MetalView {
        self.setEnvironment(\.enableSetNeedsDisplay, value)
    }

    func presentWithTransaction(_ value: Bool) -> MetalView {
        self.setEnvironment(\.presentWithTransaction, value)
    }
    
}