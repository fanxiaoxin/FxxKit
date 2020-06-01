//
//  ViewStyleType.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/3.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

public struct FXStyleSetting<TargetType> {
    public var action:(TargetType) -> Void
    public init(action: @escaping (TargetType) -> Void) {
        self.action = action
    }
}
///所有需要设置样式的都可继承该协议
public protocol FXStyleSetable { }
extension FX.NamespaceImplement where Base: FXStyleSetable {
    @discardableResult
    public func style(_ style:FXStyleSetting<Base>...) -> NamespaceWrapper<Base> {
        style.forEach({$0.action(self.base)})
        return self as! NamespaceWrapper<Base> 
    }
}
///UIView默认可设置样式
extension UIView: FXStyleSetable { }
extension FXStyleSetable where Self: UIView {
    public static func fx(_ styles:FXStyleSetting<Self>...) -> Self {
        return self.init().fx(styles: styles)
    }
    @discardableResult
    public func fx(_ styles:FXStyleSetting<Self>...) -> Self {
        return self.fx(styles: styles)
    }
    @discardableResult
    public func fx(styles:[FXStyleSetting<Self>]) -> Self {
        styles.forEach({$0.action(self)})
        return self
    }
}

extension FXStyleSetting {
    ///组合多个样式
    public static func sheet(_ styles:FXStyleSetting<TargetType>...) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            styles.forEach({ $0.action(target) })
        })
    }
    ///自定义
    public static func custom(_ action:@escaping (TargetType) -> Void) -> FXStyleSetting<TargetType> {
        return .init(action: action)
    }
}

///静态样式表
var FXStaticStyleSheets: [String:Any] = [:]
extension FX.NamespaceImplement where Base: FXStyleSetable, Base: AnyObject {
    ///设置静态样式
    public static func style(_ style:FXStyleSetting<Base>...) {
        let className = String(describing: type(of: Base.self))
        FXStaticStyleSheets[className] = style
    }
    ///加载静态样式
    public func loadStaticStyle() {
        let className = String(describing: type(of: Base.self))
        if let styles = FXStaticStyleSheets[className] as? [FXStyleSetting<Base>] {
            styles.forEach({ $0.action(self.base) })
        }
    }
}
