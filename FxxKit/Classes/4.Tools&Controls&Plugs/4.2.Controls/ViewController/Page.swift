//
//  FXPage.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

public protocol FXPageEventDelegate:AnyObject {
    func performEvent(_ name:String, params: Any?)
    ///未被触发的事件会调用该方法转发出去
    func forwardEvent(_ name:String, params: Any?)
}
extension FXPageEventDelegate where Self: NSObjectProtocol {
    public func performEvent(_ name:String, params: Any?) {
        if params != nil {
            let s = NSSelectorFromString("on"+name + ":")
            if self.responds(to: s) {
                self.perform(s, with: params)
            }else{
                self.forwardEvent(name, params: params)
            }
        }else{
            let s = NSSelectorFromString("on"+name)
            if self.responds(to: s) {
                self.perform(s)
            }else{
                self.forwardEvent(name, params: params)
            }
        }
    }
    public func forwardEvent(_ name:String, params: Any?) {
        
    }
}

///页面
open class FXPage: UIView {
    let eventKey = "FXPageEvent"
    class Event {
        var name: String
        var params: Any?
        init(_ name: String,_ params: Any? = nil) {
            self.name = name
            self.params = params
        }
    }
    open var title: String?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    ///子类重载该方法即可
    open func load() {
        
    }
    
    //****** 事件绑定 ******/
    open weak var eventDelegate: FXPageEventDelegate?
    ///绑定事件
    open func bind(_ button:UIButton,event name:String, params: Any? = nil) {
        self.bind(button, event: name, for: .touchUpInside, params: params)
    }
    ///绑定事件
    open func bind(_ control:UIControl,event name:String, for event:UIControl.Event, params: Any? = nil) {
        control.fx.setAssociated(object: Event(name, params), key: eventKey)
        control.addTarget(self, action: #selector(self.triger(control:)), for: event)
    }
    ///绑定事件
    open func bind(_ view:UIView,event name:String, params: Any? = nil) {
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        self.bind(tap, event: name, params: params)
    }
    ///绑定事件
    open func bind(_ gr:UIGestureRecognizer,event name:String, params: Any? = nil) {
        gr.fx.setAssociated(object: Event(name, params), key: eventKey)
        gr.addTarget(self, action: #selector(self.triger(gestureRecognizer:)))
    }
    ///重新绑定事件参数
    open func rebind(_ control:NSObject, params: Any?) {
        if let event: Event = control.fx.getAssociated(object: eventKey) {
            event.params = params
        }
    }
    @objc open func triger(control:UIControl) {
        if let event: Event = control.fx.getAssociated(object: eventKey) {
            self.triget(event: event.name, params: event.params)
        }
    }
    @objc open func triger(gestureRecognizer:UIGestureRecognizer) {
        if let event: Event = gestureRecognizer.fx.getAssociated(object: eventKey) {
            self.triget(event: event.name, params: event.params)
        }
    }
    open func triget(event name:String, params:Any? = nil) {
        self.eventDelegate?.performEvent(name, params: params)
    }
    //****** 事件绑定结束 ******/
    
    //****** 键盘绑定 ******/
    open var keyboardConstraint:NSLayoutConstraint?
    ///自动适应键盘滚动，该操作会自动给该view添加底部的布局，勿手动添加
    open func keyboardAdaptLayout(for view: UIView,bottom padding:CGFloat){
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: padding)
        self.addConstraint(bottom)
        self.keyboardConstraint = bottom
    }
    ///自动适应键盘滚动，该操作会自动寻找该view底部的布局，请添加后再调用
    @discardableResult
    open func keyboardAdaptLayout(for view: UIView) -> Bool {
        if let cs = self.bottomConstraint(for: view, with: self) {
            self.keyboardConstraint = cs
            return true
        }
        if let cs = self.bottomConstraint(for: self, with: view) {
            self.keyboardConstraint = cs
            return true
        }
        return false
    }
    func bottomConstraint(for view1:UIView, with view2:UIView) -> NSLayoutConstraint? {
        for cs in view1.constraints {
            if self.isConstraintBottom(cs.firstAttribute)
                && self.isConstraintBottom(cs.secondAttribute) {
                if (cs.firstItem === view1 && cs.secondItem === view2)
                || (cs.firstItem === view2 && cs.secondItem === view1) {
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
    ///点击可关闭键盘
    open func keyboardAdaptClose(for view: UIView? = nil) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(_:)))
        (view ?? self).addGestureRecognizer(tap)
    }
    @objc open func closeKeyboard(_ sender: UITapGestureRecognizer) {
        sender.view?.endEditing(true)
    }
    //****** 键盘绑定结束 ******/
    
    ///填充刘海屏上的刘海
    @discardableResult
    open func fillStraightBangs() -> UIView? {
        if UIDevice.current.fx.isStraightBangs {
            return self.fx.add(.view(.bg(.white), .height(33)), layout: .top, .marginX).base
        }else{
            return nil
        }
    }
}
extension FXPage {
    public func button(_ button: UIButton, event:String, params: Any? = nil ,_ style: FXStyleSetting<UIButton>...) -> UIButton {
        self.bind(button, event: event, params: params)
        style.forEach({$0.action(button)})
        return button
    }
    public func button(_ event:String, params: Any? = nil ,_ style: FXStyleSetting<UIButton>...) -> UIButton {
        let button = UIButton()
        self.bind(button, event: event, params: params)
        style.forEach({$0.action(button)})
        return button
    }
    public func fxButton(_ event:String, params: Any? = nil ,_ style: FXStyleSetting<FXButton>...) -> FXButton {
        let button = FXButton()
        self.bind(button, event: event, params: params)
        style.forEach({$0.action(button)})
        return button
    }
}
