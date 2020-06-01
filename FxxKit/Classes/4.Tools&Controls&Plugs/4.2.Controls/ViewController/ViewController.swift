//
//  ViewController.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
//import HandyJSON

open class FXViewController<PageType:UIView>: UIViewController, FXPageEventDelegate, FXViewControllerType {
    
    open var page: PageType!
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = (self.page as? FXPage)?.title {
            self.title = title
        }
        
        self.automaticallyAdjustsScrollViewInsets = !(self.navigationController?.isNavigationBarHidden ?? true)
        
        //添加键盘处理
        if let kc = (self.page as? FXPage)?.keyboardConstraint {
            let plug = FXViewControllerKeyboardAdaptPlug()
            plug.keyboardConstraint = kc
            self.fx.append(plug: plug)
        }
    }
    override open func loadView() {
        self.page = PageType()
        (self.page as? FXPage)?.eventDelegate = self
        self.view = self.page
    }
    ///设置进入该页面的权限
    open var preconditions: [FXViewControllerPrecondition]? { return nil }
    ///转让场景，不设置则默认Push
    open var segue: FXPresentSegue { return FXPresentSegue.push }
    ///关闭页面事件，Page中可直接用"Close"事件
    @objc open func onClose() {
        self.unload()
    }
}
