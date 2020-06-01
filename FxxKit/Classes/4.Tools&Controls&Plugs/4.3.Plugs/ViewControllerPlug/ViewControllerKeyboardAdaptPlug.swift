//
//  ViewControllerKeyboardManagerPlug.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import YYKeyboardManager

///键盘适配的插件
open class FXViewControllerKeyboardAdaptPlug: NSObject, FXViewControllerPlug, YYKeyboardObserver {
    ///设置时如果keyboardConstraint未设置则会自动去搜索最外层的ScrollView，若没有则最下层的View并设置
    open weak var controller: UIViewController? {
        didSet {
            self.tryAutoSetKeyboardConstraint()
        }
    }
    ///尝试自动设置
    func tryAutoSetKeyboardConstraint() {
        if self.keyboardConstraint == nil,let view = self.controller?.view {
            //先从ScrollView
            if let cs = self.bottomConstraint(for: view, subType: UIScrollView.self) {
                self.keyboardConstraint = cs
            }else if let cs = self.bottomConstraint(for: view, subType: UIView.self) {
                self.keyboardConstraint = cs
            }
        }
    }
    func bottomConstraint<ViewType:UIView>(for view:UIView, subType:ViewType.Type) -> NSLayoutConstraint? {
        //先从自身找
        if let cs = self.bottomConstraint(for: view.constraints, view: view, subType: subType) {
            return cs
        }
        let views = view.subviews
        if views.count > 0 {
            for i in (views.count - 1)...0 {
                if let cs = self.bottomConstraint(for: views[i].constraints, view: view, subType: subType) {
                    return cs
                }
            }
        }
        return nil
    }
    func bottomConstraint<ViewType:UIView>(for constraints:[NSLayoutConstraint], view:UIView, subType:ViewType.Type) -> NSLayoutConstraint? {
        for cs in constraints {
            if self.isConstraintBottom(cs.firstAttribute) && self.isConstraintBottom(cs.secondAttribute) {
                if (cs.firstItem === view && cs.secondItem is ViewType) ||
                (cs.secondItem === view && cs.firstItem is ViewType){
                    return cs
                }
            }
        }
        return nil
    }
    func isConstraintBottom(_ attr:NSLayoutConstraint.Attribute) -> Bool {
        if #available(iOS 8.0, *) {
            if attr == .bottom ||
                attr == .bottomMargin {
                return true
            }
        } else {
            if attr == .bottom {
                return true
            }
        }
        return false
    }
    //***** 键盘管理开始 *****
    ///该值应该为ScrollView的底部边距，在键盘出来时该值会跟着放大，只要设置该值便可自动管理
    open weak var keyboardConstraint:NSLayoutConstraint?{
        didSet{
            if self.keyboardTap == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
                self.keyboardTap = tap
            }
            self.keyboardConstraintOriginalValue = self.keyboardConstraint?.constant ?? 0
        }
    }
    open func beforeViewDidAppear(_ animated: Bool) {
        self.tryAutoSetKeyboardConstraint()
        //添加键盘管理
        if self.keyboardConstraint != nil {
            YYKeyboardManager.default().add(self)
        }
    }
    open func beforeViewWillDisappear(_ animated: Bool) {
        //去掉键盘管理
        if self.keyboardConstraint != nil {
            self.controller?.view.endEditing(true)
            YYKeyboardManager.default().remove(self)
        }
    }
    fileprivate var keyboardConstraintOriginalValue:CGFloat = 0
    fileprivate var keyboardTap:UITapGestureRecognizer?
    open func keyboardChanged(with transition: YYKeyboardTransition) {
        if let constraint = self.keyboardConstraint {
            if transition.fromVisible.boolValue && !transition.toVisible.boolValue {//从有到无
                constraint.constant = self.keyboardConstraintOriginalValue
            }else if !transition.fromVisible.boolValue && transition.toVisible.boolValue {//从无到有
                var value = transition.fromFrame.origin.y - transition.toFrame.origin.y
                if self.isConstraintBottom(constraint.firstAttribute) && (constraint.firstItem as! UIView) != self.controller?.view {
                    value = -value
                }
                constraint.constant = value
            }else{
                return
            }
            
            UIView.animate(withDuration: transition.animationDuration, animations: { () -> Void in
                self.controller?.view.layoutIfNeeded()
            })
            if let tap = self.keyboardTap {
                if transition.toVisible.boolValue {
                    if tap.view == nil {
                        self.controller?.view.addGestureRecognizer(tap)
                    }
                    tap.isEnabled = true
                }else{
                    tap.isEnabled = false
                }
            }
        }
    }
    @objc func closeKeyboard(){
        self.controller?.view.endEditing(true)
    }
    //***** 键盘管理结束 *****
}
