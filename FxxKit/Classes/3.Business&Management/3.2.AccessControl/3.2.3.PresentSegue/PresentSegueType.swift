//
//  PresentSegue.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

public protocol FXPresentSegueType {
    ///当前Controller，必须为weak
    var source: UIViewController? { get set }
    ///目标Controller，必须为weak
    var destination: UIViewController? { get set }
    
    ///继承的类使用该方法实现操作
    func performAction(completion:(()->Void)?)
    ///继承的类使用该方法实现操作
    func unwindAction()
    
    ///在当前场景后加载新的场景时会使用该方法，默认直接调用新场景的directPerform
    func performNext(segue: FXPresentSegueType, completion:(()->Void)?)
}
///自定义加载，放在destination上，source并不会调用
public protocol FXPresentSegueCustomizable: UIViewController {
    ///返回true可自定义自身加载过程
    func custom(perform segue: FXPresentSegueType, completion:(()->Void)?) -> Bool
    ///返回true可自定义自身卸载过程
    func custom(unwind segue: FXPresentSegueType) -> Bool
}
extension FXPresentSegueCustomizable {
    ///返回true可自定义自身加载过程
    public func custom(perform segue: FXPresentSegueType, completion:(()->Void)?) -> Bool {
        return false
    }
    ///返回true可自定义自身卸载过程
    public func custom(unwind segue: FXPresentSegueType) -> Bool {
        return false
    }
}
extension FXPresentSegueType {
    ///执行
    public func perform(completion:(()->Void)? = nil) {
        if let custom = self.destination as? FXPresentSegueCustomizable {
            if !custom.custom(perform: self, completion: completion) {
                self.directPerform(completion: completion)
            }
        }else{
            self.directPerform(completion: completion)
        }
    }
    ///释放
    public func unwind() {
        if let custom = self.destination as? FXPresentSegueCustomizable {
            if !custom.custom(unwind: self) {
                self.directUnwind()
            }
        }else{
            self.directUnwind()
        }
    }
    ///直接执行，外部调用请用perform()
    public func directPerform(completion:(()->Void)?) {
        if let preSegue = self.source?.fx.currentSegue {
            preSegue.performNext(segue: self, completion: completion)
        }else{
            self.performAction(completion: completion)
        }
    }
    ///直接释放，外部调用请用unwind()
    public func directUnwind() {
        self.unwindAction()
    }
    ///在当前场景后加载新的场景时会使用该方法，默认直接调用新场景的directPerform
    public func performNext(segue: FXPresentSegueType, completion:(()->Void)?) {
        segue.performAction(completion: completion)
    }
}
extension FX.NamespaceImplement where Base: UIViewController {
    public var currentSegue: FXPresentSegueType? {
        return self.getAssociated(object: "FXPresentSegueType")
    }
    internal func set(currentSegue: FXPresentSegueType?) {
        self.setAssociated(object: currentSegue, key: "FXPresentSegueType")
    }
    public func present(_ viewController: UIViewController ,segue: FXPresentSegueType){
        weak var source = self.base
        weak var destination = viewController
        var s = segue
        s.source = source
        s.destination = destination
        viewController.fx.set(currentSegue: s)
        s.perform()
    }
    public func dismiss() {
        if let segue = self.currentSegue  {
            segue.unwind()
            self.set(currentSegue: nil)
        }
    }
}
