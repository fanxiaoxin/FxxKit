//
//  ViewControllerAccessCenter.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

/*
open class FXViewControllerPrecondition: FXPrecondition<UIViewController, Any> {
    
}*/
public typealias FXViewControllerPrecondition = FXPrecondition<UIViewController, Any>

open class FXViewControllerAccessCenter: FXAccessCenter<UIViewController, Any> {
    ///单例
    public static let shared = FXViewControllerAccessCenter()
    ///将构造函数私有化，仅限单例使用
    private override init() { }
}

extension FX.NamespaceImplement where Base: UIViewController {
    @discardableResult public func check<ConditionType:FXViewControllerPrecondition>(condition:ConditionType, pass:@escaping (Any?)->Void) -> ConditionType {
        return FXViewControllerAccessCenter.shared.check(condition: condition, input: self.base, pass: pass)
    }
}
