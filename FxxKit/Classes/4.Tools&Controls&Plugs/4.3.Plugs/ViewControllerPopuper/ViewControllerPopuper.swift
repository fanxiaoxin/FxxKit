//
//  ViewControllerPopupHelper.swift
//  FXKit
//
//  Created by Fanxx on 2018/4/11.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

extension FX.NamespaceImplement where Base: UIViewController {
    ///弹出框
    public func popup(direction: FXDirection? = FXDirection.none, background:UIColor? = nil, level: UIWindow.Level = .normal, frame: CGRect? = nil, completion:(()->Void)? = nil) {
        //弹出前关掉键盘
        self.base.view.endEditing(true)
        
        let window = UIWindow(frame: frame ?? UIScreen.main.bounds)
        window.windowLevel = level
        window.rootViewController = self.base
        window.backgroundColor = background ?? UIColor(white: 0, alpha: 0.7)
        
        let dir: FXDirection
        if let d = direction {
            if d.contains(.top) { self.popupTop(completion: completion) }
            else if d.contains(.left) { self.popupLeft(completion: completion) }
            else if d.contains(.right) { self.popupRight(completion: completion) }
            else if d.contains(.bottom) { self.popupBottom(completion: completion) }
            else { self.popupCenter(completion: completion) }
            dir = d
        }else{
            dir = self.autoPopup(completion: completion)
        }
        if dir.contains(.top) { window.tag = 1 }
        else if dir.contains(.left) { window.tag = 2 }
        else if dir.contains(.bottom) { window.tag = 3  }
        else if dir.contains(.right) { window.tag = 4 }
        else { window.tag = 0 }
        
        FXWindowManager.shared.show(window)
    }
    ///弹窗关闭
    public func popupClose() {
        if let tag = self.base.view.window?.tag {
            switch tag {
            case 0:
                self.popupCenterClose()
            case 1:
                self.popupTopClose()
            case 2:
                self.popupLeftClose()
            case 3:
                self.popupBottomClose()
            case 4:
                self.popupRightClose()
            default:
                self.closeWindow()
            }
        }
    }
    ///弹出框
    private func autoPopup(completion:(()->Void)? = nil) -> FXDirection {
        let view = self.base.view!
        ///如果贴着顶部则下划，贴着底部则上划，都贴或都不贴则中间弹出
        var top = false
        var bottom = false
        var left = false
        var right = false
        for cons in view.constraints {
            if cons.firstItem === view || cons.secondItem === view {
                let a1 = cons.firstAttribute
                let a2 = cons.secondAttribute
                if (a1 == .top || a1 == .topMargin) && (a2 == .top || a2 == .topMargin) {
                    top = true
                } else if (a1 == .bottom || a1 == .bottomMargin) && (a2 == .bottom || a2 == .bottomMargin) {
                    bottom = true
                } else if (a1 == .left || a1 == .leftMargin) && (a2 == .left || a2 == .leftMargin) {
                    left = true
                } else if (a1 == .right || a1 == .rightMargin) && (a2 == .right || a2 == .rightMargin) {
                    right = true
                }
            }
        }
        if top != bottom && left == right {
            if top {
                self.popupTop(completion: completion)
                return .top
            }else{
                self.popupBottom(completion: completion)
                return .bottom
            }
        } else if left != right && top == bottom {
            if left {
                self.popupLeft(completion: completion)
                return .left
            }else{
                self.popupRight(completion: completion)
                return .right
            }
        }else{
            self.popupCenter(completion: completion)
            return .none
        }
    }
    ///弹出框
    private func popupCenter(completion:(()->Void)? = nil) {
        let view = self.base.view!
        view.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
        UIView.animate(withDuration: 0.25, animations:{
            view.transform = CGAffineTransform.identity
        }, completion: { _ in completion?() })
    }
    ///弹窗关闭
    private func popupCenterClose() {
        UIView.animate(withDuration: 0.25, animations: {
            self.base.view.transform = CGAffineTransform(scaleX: 0.1,y: 0.1)
        }) { (ok) in
            self.closeWindow()
        }
    }
    ///弹出框
    private func popupTop(completion:(()->Void)? = nil) {
        let view = self.base.view!
        view.frame.origin.y = -view.frame.size.height
        UIView.animate(withDuration: 0.25, animations: {
            view.frame.origin.y = 0
        }, completion: { _ in completion?() })
    }
    ///弹窗关闭
    private func popupTopClose() {
        UIView.animate(withDuration: 0.25, animations: {
            let view = self.base.view!
            view.frame.origin.y = -view.frame.size.height
        }) { (ok) in
            self.closeWindow()
        }
    }
    ///弹出框
    private func popupBottom(completion:(()->Void)? = nil) {
        let view = self.base.view!
        let height = view.frame.size.height
        view.frame.origin.y = height == 0 ? UIScreen.main.bounds.size.height : height
        UIView.animate(withDuration: 0.25, animations: {
            view.frame.origin.y = 0
        }, completion: { _ in completion?() })
    }
    ///弹窗关闭
    private func popupBottomClose() {
        UIView.animate(withDuration: 0.25, animations: {
            let view = self.base.view!
            view.frame.origin.y = view.frame.size.height
        }) { (ok) in
            self.closeWindow()
        }
    }
    
    ///弹出框
    private func popupRight(completion:(()->Void)? = nil) {
        let view = self.base.view!
        view.frame.origin.x = view.frame.size.width
        UIView.animate(withDuration: 0.25, animations: {
            view.frame.origin.x = 0
        }, completion: { _ in completion?() })
    }
    ///弹窗关闭
    private func popupRightClose() {
        UIView.animate(withDuration: 0.25, animations: {
            let view = self.base.view!
            view.frame.origin.x = view.frame.size.width
        }) { (ok) in
            self.closeWindow()
        }
    }
    ///弹出框
    private func popupLeft(background:UIColor? = nil, completion:(()->Void)? = nil) {
        let view = self.base.view!
        view.frame.origin.x = -view.frame.size.width
        UIView.animate(withDuration: 0.25, animations: {
            view.frame.origin.x = 0
        }, completion: { _ in completion?() })
    }
    ///弹窗关闭
    private func popupLeftClose() {
        UIView.animate(withDuration: 0.25, animations: {
            let view = self.base.view!
            view.frame.origin.x = -view.frame.size.width
        }) { (ok) in
            self.closeWindow()
        }
    }
}
extension FXPresentSegue {
    ///Popup的场景
    open class Popup: FXPresentSegue {
        public static var backgroundColor: UIColor? = nil
        public var backgroundColor: UIColor?
        public var windowLevel: UIWindow.Level = .normal
        public var windowFrame: CGRect? = nil
        public var direction: FXDirection? = FXDirection.none
        
        open override func performAction(completion: (() -> Void)?) {
            self.destination?.fx.popup(direction: self.direction, background: self.backgroundColor ?? Popup.backgroundColor, level: self.windowLevel, frame: self.windowFrame, completion: completion)
        }
        open override func unwindAction() {
            self.destination?.fx.popupClose()
        }
        open override func performNext(segue: FXPresentSegueType, completion: (() -> Void)?) {
            self.unwind()
            var s = segue
            s.source = self.source ?? s.source
            s.performAction(completion: completion)
        }
    }
    ///Popup的常规场景
    public static var popup: Popup { return Popup() }
    ///Popup的常规场景
    public static func popup(alpha: CGFloat? = nil, direction: FXDirection? = FXDirection.none) -> Popup {
        let p = Popup()
        if let a = alpha {
            p.backgroundColor = UIColor(white: 0, alpha: a)
        }
        p.direction = direction
        return p
    }
}
extension FXPresentSegue {
    ///Popup并则原先的卸载的场景
    open class PopupReplace: Popup {
        open override func performAction(completion: (() -> Void)?) {
            if let source = self.source, let segue = source.fx.currentSegue  {
                ///将上一级卸载
                source.fx.dismiss()
                ///将Source定位到再上一级
                self.source = segue.source
            }
            super.performAction(completion: completion)
        }
    }
    ///Popup并则原先的卸载的场景
    public static var popupReplace: PopupReplace { return PopupReplace() }
}
