//
//  CornerRadius.swift
//  Movies App
//
//  Created by Vladimir Kozlov on 23.06.2024.
//

import Foundation

public enum CornerRadius {
    /// 2
    public static var xs2: CGFloat { 2 * DeviceType.multiplier }
    /// 4
    public static var xs: CGFloat { 4 * DeviceType.multiplier }
    /// 8
    public static var s: CGFloat { 8 * DeviceType.multiplier }
    /// 10
    public static var m: CGFloat { 10 * DeviceType.multiplier }
    /// 12
    public static var l: CGFloat { 12 * DeviceType.multiplier }
    /// 14
    public static var xl: CGFloat { 14 * DeviceType.multiplier }
    /// 16
    public static var xl2: CGFloat { 16 * DeviceType.multiplier }
    /// 20
    public static var xl3: CGFloat { 20 * DeviceType.multiplier }
}
