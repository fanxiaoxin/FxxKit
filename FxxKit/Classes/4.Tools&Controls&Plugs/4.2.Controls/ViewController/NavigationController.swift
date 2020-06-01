//
//  NavigationController.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

open class FXNavigationController: UINavigationController,UIGestureRecognizerDelegate, FXViewControllerType {
    ///可由外部设置
    open var segue: FXPresentSegue = FXPresentSegue.push
    
    ///可由外部设置
    open var preconditions: [FXViewControllerPrecondition]? = nil
    ///只有根控制器显示Tabbar
    open var onlyRootControllerShowBottomBar = true
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
        super.pushViewController(rootViewController, animated: false)
        self.initialize()
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    func initialize(){
        self.interactivePopGestureRecognizer?.delegate = self
    }
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.onlyRootControllerShowBottomBar {
            ///只有第一个才显示tab bar
            if let first = self.viewControllers.first, first != viewController{
                viewController.hidesBottomBarWhenPushed = true
            }else{
                viewController.hidesBottomBarWhenPushed = false
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if self.onlyRootControllerShowBottomBar {
            ///只有第一个才显示tab bar
            for c in viewControllers {
                c.hidesBottomBarWhenPushed = true
            }
            viewControllers.first?.hidesBottomBarWhenPushed = false
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            return self.topViewController != self.viewControllers.first
        }
        return true
    }
}
