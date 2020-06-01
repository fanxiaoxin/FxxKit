//
//  UIViewControllerExtension.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/27.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

//extension UINavigationController: FXNamespaceWrappable {}
extension FX.NamespaceImplement where Base == UIViewController {
    public static var current: UIViewController? {
        if var target = UIApplication.shared.delegate?.window??.rootViewController {
            repeat {
                if let c = target.fx.__upLayerViewController() {
                    target = c
                }else{
                    break
                }
            } while (true)
            return target
        }
        return nil
    }
    ///获取上一层Controller
    func __upLayerViewController() -> UIViewController? {
        if let target = self.base.presentedViewController {
            return target
        }
        if let tb = self.base as? UITabBarController, let target = tb.selectedViewController {
            return target
        }
        if let nv = self.base as? UINavigationController, let target = nv.topViewController {
            return target
        }
        return nil
    }
}
extension FX.NamespaceImplement where Base: UINavigationController {
    @discardableResult public func pop(to viewControllerType:AnyClass,creation:(() -> UIViewController)? = nil, animated: Bool = true) -> [UIViewController]? {
        var controllers = self.base.viewControllers
        while let last = controllers.last {
            if last.isKind(of: viewControllerType) {
                return self.base.popToViewController(last, animated: animated)
            }else{
                controllers.removeLast()
            }
        }
        if let controller = creation?() {
            self.base.pushViewController(controller, animated: animated)
        }
        return self.base.viewControllers
    }
    public func replace(_ viewController:UIViewController, level: Int = 0, animated: Bool = true) {
        var controllers = self.base.viewControllers
        let range = Range<Int>(uncheckedBounds: (lower: controllers.count - level, upper: controllers.count))
        controllers.replaceSubrange(range, with: [viewController])
        self.base.setViewControllers(controllers, animated: animated)
    }
    public func pop(count:Int = 1,animated: Bool = true) {
        if count < 2 {
            self.base.popViewController(animated: animated)
        }else if self.base.viewControllers.count - 1 > count {
            let target = self.base.viewControllers[self.base.viewControllers.count - 1 - count]
            self.base.popToViewController(target, animated: animated)
        }else{
            self.base.popToRootViewController(animated: animated)
        }
    }
    public func push(_ viewControllers:[UIViewController], animated: Bool) {
        var cs = self.base.viewControllers
        cs.append(contentsOf: viewControllers)
        self.base.setViewControllers(cs, animated: animated)
    }
}
