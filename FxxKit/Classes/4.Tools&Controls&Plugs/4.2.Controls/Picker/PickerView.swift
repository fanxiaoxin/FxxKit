//
//  FXPickerView.swift
//  FXKit
//
//  Created by Fanxx on 2018/4/17.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

open class FXPickerView : UIView{
    ///可配置样式
    open class Style {
        ///标题颜色
        public static var titleColor: UIColor? = UIColor.black
        ///标题字体
        public static var titleFont: UIFont? = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        ///按钮颜色
        public static var buttonColor: UIColor? = UIColor.black
        ///按钮点击颜色
        public static var buttonHoverColor: UIColor? = UIColor.black
        ///按钮字体
        public static var buttonFont: UIFont? = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        ///边框颜色
        public static var borderColor: UIColor? = UIColor.lightGray
    }
    public let animateDuration : TimeInterval = 0.25
    let bgTapGR = UITapGestureRecognizer()
    let container = UIView()
    public let contentView : UIView!
    
    open var title : String?
    open var confirmAction : (() -> Void)? = nil
    open var cancelAction : (() -> Void)? = nil
    open var hideWhenTouchBackground : Bool {
        set{
            bgTapGR.isEnabled = newValue
        }
        get{
            return bgTapGR.isEnabled
        }
    }
    public init(title:String?,contentView:UIView){
        self.contentView = contentView
        super.init(frame:CGRect.zero)
        self.title = title
        self.hideWhenTouchBackground = true
        self.loadLayoutAndStyle()
        bgTapGR.addTarget(self, action: #selector(self.touchBackground(_:)))
        self.addGestureRecognizer(bgTapGR)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func touchBackground(_ gr:UITapGestureRecognizer){
        if !container.frame.contains(gr.location(in: self)) {
            self.doCancel()
        }
    }
    fileprivate func loadLayoutAndStyle(){
        //自身为背景遮罩
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(white: 0.2, alpha: 0.4)
        //主体
        //        let container = UIView()
        container.isUserInteractionEnabled = true
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        self.addSubview(container)
        //布局约束
        let containerConsBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0)
        let containerConsLeft = NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
        let containerConsRight = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1.0, constant: 0)
        self.addConstraints([containerConsBottom,containerConsLeft,containerConsRight])
        //标题
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = self.title
        titleLabel.textColor = FXPickerView.Style.titleColor
        titleLabel.font = FXPickerView.Style.titleFont
        titleLabel.textAlignment = .center
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = FXPickerView.Style.borderColor?.cgColor
        container.addSubview(titleLabel)
        //布局约束
        let titleConsTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: -1)
        let titleConsLeft = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1.0, constant: -1)
        let titleConsRight = NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1.0, constant: -1)
        container.addConstraints([titleConsTop,titleConsLeft,titleConsRight])
        
        let titleConsHeight = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 56)
        titleLabel.addConstraint(titleConsHeight)
        //按钮
        let confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitleColor(FXPickerView.Style.buttonColor, for: .normal)
        confirmButton.setTitleColor(FXPickerView.Style.buttonHoverColor, for: .highlighted)
        confirmButton.titleLabel?.font = FXPickerView.Style.buttonFont
        confirmButton.backgroundColor = UIColor.clear
        confirmButton.contentHorizontalAlignment = .right
        confirmButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        confirmButton.setTitle("确定", for: .normal)
        container.addSubview(confirmButton)
        confirmButton.addTarget(self, action: #selector(self.doConfirm), for: .touchUpInside)
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(FXPickerView.Style.buttonColor, for: .normal)
        cancelButton.setTitleColor(FXPickerView.Style.buttonHoverColor, for: .highlighted)
        cancelButton.titleLabel?.font = FXPickerView.Style.buttonFont
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        cancelButton.setTitle("取消", for: .normal)
        container.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(self.doCancel), for: .touchUpInside)
        //布局约束
        let confirmConsTop = NSLayoutConstraint(item: confirmButton, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0)
        let confirmConsRight = NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: confirmButton, attribute: .right, multiplier: 1.0, constant: 0)
        let confirmConsHeight = NSLayoutConstraint(item: confirmButton, attribute: .height, relatedBy: .equal, toItem: titleLabel, attribute: .height, multiplier: 1.0, constant: -1)
        let confirmConsWidth = NSLayoutConstraint(item: confirmButton, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 0.3333, constant: 0)
        let cancelConsTop = NSLayoutConstraint(item: cancelButton, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0)
        let cancelConsLeft = NSLayoutConstraint(item: cancelButton, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1.0, constant: 0)
        let cancelConsHeight = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: titleLabel, attribute: .height, multiplier: 1.0, constant: -1)
        let cancelConsWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 0.3333, constant: 0)
        container.addConstraints([confirmConsTop,confirmConsRight,confirmConsHeight,confirmConsWidth,cancelConsTop,cancelConsLeft,cancelConsHeight,cancelConsWidth])
        //选择器
        container.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        //布局约束
        let pickerConsTop = NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: self.contentView.frame.origin.y)
        let pickerConsLeft = NSLayoutConstraint(item: self.contentView, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1.0, constant: self.contentView.frame.origin.x)
        let pickerConsRight = NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant: self.contentView.frame.origin.x)
        let pickerConsBottom = NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 0)
        container.addConstraints([pickerConsTop,pickerConsLeft,pickerConsRight,pickerConsBottom])
        
        let containerConsHeight = NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 1.0, constant: 55)
        container.addConstraint(containerConsHeight)
    }
    @objc func doConfirm(){
        self.confirmAction?()
    }
    @objc func doCancel(){
        self.cancelAction?()
        self.hide()
    }
    open func show(_ to:UIView){
        self.alpha = 0
        to.addSubview(self)
        to.addConstraints([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: to, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: to, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: to, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: to, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
            ])
        self.layoutIfNeeded()
        UIView.animate(withDuration: self.animateDuration, animations: { () -> Void in
            self.alpha = 1
        })
    }
    open func hide(){
        UIView.animate(withDuration: self.animateDuration, animations: { () -> Void in
            self.alpha = 0
        }, completion:{ (finish) -> Void in
            self.removeFromSuperview()
        })
    }
}
