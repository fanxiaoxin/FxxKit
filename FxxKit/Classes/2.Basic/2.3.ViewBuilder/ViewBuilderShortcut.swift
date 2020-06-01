//
//  ViewBuilderShortcut.swift
//  FXKit
//
//  Created by Fanxx on 2019/12/20.
//

import UIKit

public protocol FXBuildable {
}
extension UIView: FXBuildable{}
extension FXBuildable where Self: UIView {
    public static func build(_ builder:(NamespaceWrapper<Self>) -> Void) -> Self {
        let b = Self()
        builder(b.fx)
        return b
    }
    public func build(_ builder:(NamespaceWrapper<Self>) -> Void) -> Self {
        builder(self.fx)
        return self
    }
}

extension Array where Element: UIView {
    ///重复生成类似视图
    public static func `repeat`<ParamsType>(_ parameters: [ParamsType], builder: (NamespaceWrapper<Element>,ParamsType) -> Void) -> [Element] {
        return Element.fx.repeat(parameters, builder: builder)
    }
}
