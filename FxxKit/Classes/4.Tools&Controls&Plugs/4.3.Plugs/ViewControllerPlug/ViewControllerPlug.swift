//
//  FXViewControllerPlug.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import JRSwizzle

///ViewController插件
@objc public protocol FXViewControllerPlug {
    weak var controller: UIViewController? { get set }
    @objc optional func beforeViewDidLoad()
    @objc optional func beforeViewWillAppear(_ animated: Bool)
    @objc optional func beforeViewDidAppear(_ animated: Bool)
    @objc optional func beforeViewWillDisappear(_ animated: Bool)
    @objc optional func beforeViewDidDisappear(_ animated: Bool)
    @objc optional func beforeViewWillLayoutSubviews()
    @objc optional func beforeViewDidLayoutSubviews()
    @objc optional func afterViewDidLoad()
    @objc optional func afterViewWillAppear(_ animated: Bool)
    @objc optional func afterViewDidAppear(_ animated: Bool)
    @objc optional func afterViewWillDisappear(_ animated: Bool)
    @objc optional func afterViewDidDisappear(_ animated: Bool)
    @objc optional func afterViewWillLayoutSubviews()
    @objc optional func afterViewDidLayoutSubviews()
}

fileprivate var __viewControllerPlugsSwizzled: Bool = false
fileprivate let __viewControllerPlugsSwizzleLock: Int = 0
///切换插件方法
func __fxSwizzleViewControllerPlugs() {
    ///如果未切换过方法，则切换
    if !__viewControllerPlugsSwizzled {
        objc_sync_enter(__viewControllerPlugsSwizzleLock)
        if !__viewControllerPlugsSwizzled {
            __viewControllerPlugsSwizzled = true
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidLoad), withMethod: #selector(UIViewController.fxPlugsViewDidLoad))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewWillAppear(_:)), withMethod: #selector(UIViewController.fxPlugsViewWillAppear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidAppear(_:)), withMethod: #selector(UIViewController.fxPlugsViewDidAppear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewWillDisappear(_:)), withMethod: #selector(UIViewController.fxPlugsViewWillDisappear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidDisappear(_:)), withMethod: #selector(UIViewController.fxPlugsViewDidDisappear(_:)))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewWillLayoutSubviews), withMethod: #selector(UIViewController.fxPlugsViewWillLayoutSubviews))
            try? UIViewController.jr_swizzleMethod(#selector(UIViewController.viewDidLayoutSubviews), withMethod: #selector(UIViewController.fxPlugsViewDidLayoutSubviews))
        }
        objc_sync_exit(__viewControllerPlugsSwizzleLock)
    }
}
extension FX.NamespaceImplement where Base: UIViewController {
    public var plugs: [FXViewControllerPlug]? {
        return self.getAssociated(object:"fxPlugs")
    }
    public func plugs(_ plugs:[FXViewControllerPlug]?) {
        plugs?.forEach({ $0.controller = self.base })
        self.setAssociated(object: plugs, key: "fxPlugs")
        __fxSwizzleViewControllerPlugs()
    }
    ///在保留现有插件的基础上添加插件
    public func append(plug:FXViewControllerPlug) {
        self.append(plugs: [plug])
    }
    ///在保留现有插件的基础上添加插件
    public func append(plugs:[FXViewControllerPlug]) {
        if var ps = self.plugs {
            ps.append(contentsOf: plugs)
            self.plugs(ps)
        }else{
            self.plugs(plugs)
        }
    }
}
var __fxViewControllerPlugs: [FXViewControllerPlug]?
extension FX.NamespaceImplement where Base: UIViewController {
    public static var plugs: [FXViewControllerPlug]? {
        return __fxViewControllerPlugs
        
    }
    ///静态的Plugs中的controller是空的，需要注意
    public static func plugs(_ plugs:[FXViewControllerPlug]?) {
        __fxViewControllerPlugs = plugs
        __fxSwizzleViewControllerPlugs()
    }
    ///在保留现有插件的基础上添加插件
    public static func append(plug:FXViewControllerPlug) {
        self.append(plugs: [plug])
    }
    ///在保留现有插件的基础上添加插件
    public static func append(plugs:[FXViewControllerPlug]) {
        if var ps = self.plugs {
            ps.append(contentsOf: plugs)
            self.plugs(ps)
        }else{
            self.plugs(plugs)
        }
    }
}

extension UIViewController {
    
    @objc func fxPlugsViewDidLoad() {
        UIViewController.fx.plugs?.forEach({ $0.beforeViewDidLoad?() })
        self.fx.plugs?.forEach({ $0.beforeViewDidLoad?() })
        self.fxPlugsViewDidLoad()
        self.fx.plugs?.forEach({ $0.afterViewDidLoad?() })
        UIViewController.fx.plugs?.forEach({ $0.afterViewDidLoad?() })
    }
    @objc func fxPlugsViewWillAppear(_ animated: Bool) {
        UIViewController.fx.plugs?.forEach({ $0.beforeViewWillAppear?(animated) })
        self.fx.plugs?.forEach({ $0.beforeViewWillAppear?(animated) })
        self.fxPlugsViewWillAppear(animated)
        self.fx.plugs?.forEach({ $0.afterViewWillAppear?(animated) })
        UIViewController.fx.plugs?.forEach({ $0.afterViewWillAppear?(animated) })
    }
    @objc func fxPlugsViewDidAppear(_ animated: Bool) {
        UIViewController.fx.plugs?.forEach({ $0.beforeViewDidAppear?(animated) })
        self.fx.plugs?.forEach({ $0.beforeViewDidAppear?(animated) })
        self.fxPlugsViewDidAppear(animated)
        self.fx.plugs?.forEach({ $0.afterViewDidAppear?(animated) })
        UIViewController.fx.plugs?.forEach({ $0.afterViewDidAppear?(animated) })
    }
    @objc func fxPlugsViewWillDisappear(_ animated: Bool) {
        UIViewController.fx.plugs?.forEach({ $0.beforeViewWillDisappear?(animated) })
        self.fx.plugs?.forEach({ $0.beforeViewWillDisappear?(animated) })
        self.fxPlugsViewWillDisappear(animated)
        self.fx.plugs?.forEach({ $0.afterViewWillDisappear?(animated) })
        UIViewController.fx.plugs?.forEach({ $0.afterViewWillDisappear?(animated) })
    }
    @objc func fxPlugsViewDidDisappear(_ animated: Bool) {
        UIViewController.fx.plugs?.forEach({ $0.beforeViewDidDisappear?(animated) })
        self.fx.plugs?.forEach({ $0.beforeViewDidDisappear?(animated) })
        self.fxPlugsViewDidDisappear(animated)
        self.fx.plugs?.forEach({ $0.afterViewDidDisappear?(animated) })
        UIViewController.fx.plugs?.forEach({ $0.afterViewDidDisappear?(animated) })
    }
    @objc func fxPlugsViewWillLayoutSubviews() {
        UIViewController.fx.plugs?.forEach({ $0.beforeViewWillLayoutSubviews?() })
        self.fx.plugs?.forEach({ $0.beforeViewWillLayoutSubviews?() })
        self.fxPlugsViewWillLayoutSubviews()
        self.fx.plugs?.forEach({ $0.afterViewWillLayoutSubviews?() })
        UIViewController.fx.plugs?.forEach({ $0.afterViewWillLayoutSubviews?() })
    }
    @objc func fxPlugsViewDidLayoutSubviews() {
        UIViewController.fx.plugs?.forEach({ $0.beforeViewDidLayoutSubviews?() })
        self.fx.plugs?.forEach({ $0.beforeViewDidLayoutSubviews?() })
        self.fxPlugsViewDidLayoutSubviews()
        self.fx.plugs?.forEach({ $0.afterViewDidLayoutSubviews?() })
        UIViewController.fx.plugs?.forEach({ $0.afterViewDidLayoutSubviews?() })
    }
}
