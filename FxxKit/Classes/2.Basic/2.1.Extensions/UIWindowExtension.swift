//
//  UIWindowExtension.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/27.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

extension FX.NamespaceImplement where Base: UIWindow {
    ///当前显示的Controller(不包含Nav和Tab)
    public var currentViewController: UIViewController? {
        if var tg = self.base.rootViewController {
            while let c = self.uplayerViewController(from: tg) {
                tg = c
            }
            return tg
        }
        return nil
    }
    ///当前显示的Contrller的NavigationController
    public var currentNavigationController: UINavigationController? {
        return self.currentViewController?.navigationController
    }
    ///当前显示的Controller的TabbarController
    public var currentTabBarController: UITabBarController? {
        return self.currentViewController?.tabBarController
    }
    ///当前显示的页面，如有Navigation则返回Navigation，如有Tabbar则返回Tabbar，如都没则返回该页面
//    public var currentFrameController: UIViewController? {
//
//    }
    ///获取上一层Controller
    func uplayerViewController(from controller:UIViewController) -> UIViewController? {
        if let c = controller.presentedViewController { return c }
        if let c = controller as? UITabBarController {
            if let sc = c.selectedViewController { return sc }
        }
        if let c = controller as? UINavigationController {
            if let sc = c.topViewController { return sc }
        }
        return nil
    }
}

