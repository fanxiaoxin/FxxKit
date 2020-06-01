//
//  Number+FXAdd.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation
import UIKit

public protocol FXNumberExt: FX.NamespaceDefine{
    var oc:NSNumber { get }
}

extension FXNumberExt {
    ///千分符表示法
    public func thousandSeparatorsDescription(_ decimalLength:Int = 0) -> String {
        let formatter = NumberFormatter()
        let format = NSMutableString(string:"###,##0")
        if (decimalLength > 0) {
            format.append(".")
            for _ in 0...decimalLength - 1 {
                format.append("0")
            }
        }
        formatter.positiveFormat = format as String?
        return formatter.string(from: self.oc) ?? (decimalLength > 0 ? "0" + format.substring(from: 7) : "0")
    }
    ///格式化字符串
    public func description(_ format:String) -> String {
        let formatter = NumberFormatter()
        formatter.positiveFormat = format
        return formatter.string(from: self.oc) ?? self.oc.description
    }
    public func between(_ v1: Self, _ v2: Self) -> Bool {
        return v1.oc.doubleValue < self.oc.doubleValue && v2.oc.doubleValue > self.oc.doubleValue
    }
}

extension Int: FXNumberExt {
    public var oc: NSNumber { return self as NSNumber }
}
extension Double: FXNumberExt {
    public var oc: NSNumber { return self as NSNumber }
}
extension Float: FXNumberExt {
    public var oc: NSNumber { return self as NSNumber }
}
extension CGFloat: FXNumberExt {
    public var oc: NSNumber { return self as NSNumber }
}
extension Decimal: FXNumberExt {
    public var oc: NSNumber { return self as NSNumber }
}


extension CGFloat: FX.NamespaceDefine { }
extension FX.NamespaceImplement where Base == CGFloat {
    public static var pixel: CGFloat {
        return pixels(1)
    }
    ///计算像素值
    public static func pixels(_ p:CGFloat) -> CGFloat{
        return p / UIScreen.main.scale
    }
}

extension Decimal: FX.NamespaceDefine { }
extension FX.NamespaceImplement where Base == Decimal {
    public func round(_ scale:Int, mode:NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var source = self.base
        NSDecimalRound(&result, &source, scale, mode)
        return result
    }
}

extension CGSize {
    public static func fx(_ widthHeight: CGFloat) -> CGSize {
        return CGSize(width: widthHeight, height: widthHeight)
    }
    public static func fx(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
}
extension CGPoint {
    public static func fx(_ xy: CGFloat) -> CGPoint {
        return CGPoint(x: xy, y: xy)
    }
    public static func fx(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    public static func fx(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}
extension CGRect {
    public static func fx(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    public static func fx(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    public static func fx(_ width: CGFloat,_ height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    public static func fx(_ size: CGSize) -> CGRect {
        return CGRect(origin: .zero, size: size)
    }
}
extension UIEdgeInsets {
    public static func fx(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    public static func fx(x: CGFloat = 0, y: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
    public static func fx(_ xy: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: xy, left: xy, bottom: xy, right: xy)
    }
}
