//
//  Size.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

public enum Size {
    /// { 1, 1 }
    public static var xs4: CGSize { CGSize(square: 1 * DeviceType.multiplier) }
    /// { 2, 2 }
    public static var xs3: CGSize { CGSize(square: 2 * DeviceType.multiplier) }
    /// { 4, 4 }
    public static var xs2: CGSize { CGSize(square: 4 * DeviceType.multiplier) }
    /// { 8, 8 }
    public static var xs: CGSize { CGSize(square: 8 * DeviceType.multiplier) }
    /// { 12, 12 }
    public static var s: CGSize { CGSize(square: 12 * DeviceType.multiplier) }
    /// { 16, 16 }
    public static var m: CGSize { CGSize(square: 16 * DeviceType.multiplier) }
    /// { 20, 20 }
    public static var l: CGSize { CGSize(square: 20 * DeviceType.multiplier) }
    /// { 24, 24 }
    public static var xl: CGSize { CGSize(square: 24 * DeviceType.multiplier) }
    /// { 28, 28 }
    public static var xl2: CGSize { CGSize(square: 28 * DeviceType.multiplier) }
    /// { 32, 32 }
    public static var xl3: CGSize { CGSize(square: 32 * DeviceType.multiplier) }
    /// { 36, 36 }
    public static var xl4: CGSize { CGSize(square: 36 * DeviceType.multiplier) }
    /// { 40, 40 }
    public static var xl5: CGSize { CGSize(square: 40 * DeviceType.multiplier) }
    /// { 48, 48 }
    public static var xl6: CGSize { CGSize(square: 48 * DeviceType.multiplier) }
}
