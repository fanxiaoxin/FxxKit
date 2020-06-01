//
//  FqyAlertController.swift
//  ManageFinances
//
//  Created by Fanxx on 16/7/7.
//  Copyright © 2016年 YinChengPai. All rights reserved.
//

import UIKit
import YYKeyboardManager

open class FXAlertController: UIViewController,YYKeyboardObserver {
    ///控制控件的样式，只能在初始化时赋值才会生效
    public struct Stylesheet {
        var padding: CGFloat = 15
        var titleFont: UIFont = .boldSystemFont(ofSize: 14)
        var messageFont: UIFont = .systemFont(ofSize: 14)
        var fontColor: UIColor = .darkText
        var separatorColor: UIColor = .darkGray
        
        var buttonFont: UIFont = .boldSystemFont(ofSize: 15)
        var buttonFontColor: UIColor = .darkText
        var buttonDestructiveColor: UIColor = .black
        
        static var `default`: Stylesheet {
            return Stylesheet()
        }
    }
    open var stylesheet: Stylesheet!
    
    public var contentView : UIView?
    public var buttons:[String]?
    public var destructiveIndex:Int?
    public var action:((Int)->Void)?
    
    public let titleLabel = UILabel()
    public let container = UIView()
    public let contentScrollView = UIScrollView()
    public let separator = UIView()
    public let buttonsView = UIView()
    public let backgroundView = UIView()
    override open func viewDidLoad() {
        super.viewDidLoad()
        if let title = self.title, !title.isEmpty {
            self.titleLabel.text = title
        }else{
            self.titleLabel.snp.updateConstraints { (make) in
                make.height.equalTo(10)
            }
        }
        if let contentView = self.contentView {
            //内容
            self.contentScrollView.isUserInteractionEnabled = true
            self.contentScrollView.addSubview(contentView)
            contentView.snp.makeConstraints( { (make) in
                make.edges.equalTo(self.contentScrollView).inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
                make.width.equalTo(self.contentScrollView).offset(-20)
                //尽量高度相等，不滚动，但若大于最大高度则需滚动，所以优先级为中
                make.height.equalTo(self.contentScrollView).offset(-10).priority(500)
            })
            //按钮
            if let buttons = self.buttons, buttons.count > 0 {
                //两个按钮时横向并列，其他纵向并列
                if buttons.count > 2 {
                    var btn = buttonsView.fx.add(self.createButton(0), layout: .top, .marginX)
                    btn.base.snp.makeConstraints { (make) in
                        make.height.equalTo(40).priority(.low)
                    }
                    for i in 1..<buttons.count {
                        btn = btn.next(self.createButton(i), layout: .bottomTop(CGFloat.fx.pixel), .paddingX, .height)
                    }
                    btn.parent(.bottom)
                }else{
                    var btn = buttonsView.fx.add(self.createButton(0), layout: .left, .marginY)
                    btn.base.snp.makeConstraints { (make) in
                        make.height.equalTo(40).priority(.low)
                    }
                    for i in 1..<buttons.count {
                        btn = btn.next(self.createButton(i), layout: .rightLeft(CGFloat.fx.pixel), .paddingY, .height, .width)
                    }
                    btn.parent(.right)
                }
            }else{
                separator.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
                buttonsView.snp.makeConstraints( { (make) in
                    make.height.equalTo(0)
                })
            }
        }
        ///加载默认样式
        self.fx.loadStaticStyle()
    }
    override open func loadView() {
        if self.stylesheet == nil {
            self.stylesheet = Stylesheet.default
        }
        let sView = UIView()
        sView.backgroundColor = UIColor(white: 0.1, alpha: 0.4)
        
        self.backgroundView.backgroundColor = UIColor.clear
        sView.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(sView)
            make.left.equalTo(sView)
            make.right.equalTo(sView)
        }
        self.bottomConstraint = NSLayoutConstraint(item: sView, attribute: .bottom, relatedBy: .equal, toItem: self.backgroundView, attribute: .bottom, multiplier: 1, constant: 0)
        sView.addConstraint(self.bottomConstraint!)
        
        let view = self.backgroundView
        
        //窗口容器
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.lessThanOrEqualTo(view).multipliedBy(0.9)
        }
        //圆角
        container.layer.cornerRadius = 3
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.white
        
        //标题
        self.titleLabel.font = self.stylesheet.titleFont
        self.titleLabel.textColor = self.stylesheet.fontColor
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        container.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(container)
            make.left.equalTo(container).offset(self.stylesheet.padding)
            make.right.equalTo(container).offset(-self.stylesheet.padding)
            make.height.equalTo(50)
        }
        
        //内容容器
        view.addSubview(self.contentScrollView)
        self.contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.equalTo(container)
            make.right.equalTo(container)
        }
        
        //分割线
        separator.backgroundColor = self.stylesheet.separatorColor
        container.addSubview(separator)
        separator.snp.makeConstraints({ (make) in
            make.top.equalTo(self.contentScrollView.snp.bottom)
            make.left.equalTo(container).offset(self.stylesheet.padding)
            make.right.equalTo(container).offset(-self.stylesheet.padding)
            make.height.equalTo(CGFloat.fx.pixel)
        })
        
        //按钮
        buttonsView.backgroundColor = self.stylesheet.separatorColor
        container.addSubview(buttonsView)
        buttonsView.snp.makeConstraints( { (make) in
            make.top.equalTo(separator.snp.bottom)
            make.left.equalTo(container)
            make.right.equalTo(container)
            make.bottom.equalTo(container)
        })
        
        self.view = sView
    }
    ///创建按钮
    func createButton(_ index:Int) -> UIButton {
        let buttons = self.buttons!
        let button = UIButton()
        button.tag = index
        button.setTitle(buttons[index], for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = self.stylesheet.buttonFont
        if let des = self.destructiveIndex, des == index{
            button.setTitleColor(self.stylesheet.buttonDestructiveColor, for: .normal)
        }else{
            button.setTitleColor(self.stylesheet.buttonFontColor, for: .normal)
        }
        button.addTarget(self, action: #selector(doAction), for: .touchUpInside)
        
        return button
    }
    @objc func doAction(_ button:UIButton){
        self.action?(button.tag)
    }
    //控制键盘
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //添加键盘管理
        if self.bottomConstraint != nil {
            YYKeyboardManager.default().add(self)
        }
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //去掉键盘管理
        if self.bottomConstraint != nil {
            YYKeyboardManager.default().remove(self)
        }
    }
    var bottomConstraint:NSLayoutConstraint?{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
            self.keyboardTap = tap
        }
    }
    fileprivate var keyboardTap:UITapGestureRecognizer?
    public func keyboardChanged(with transition: YYKeyboardTransition) {
        if let constraint = self.bottomConstraint {
            let offset:CGFloat
            if transition.fromVisible.boolValue && !transition.toVisible.boolValue {//从有到无
                offset = self.bottomLayoutGuide.length
            }else if !transition.fromVisible.boolValue && transition.toVisible.boolValue {//从无到有
                offset = -self.bottomLayoutGuide.length
            }else{
                offset = 0
            }
            constraint.constant += transition.fromFrame.origin.y - transition.toFrame.origin.y + offset
            UIView.animate(withDuration: transition.animationDuration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            if let tap = self.keyboardTap {
                if transition.toVisible.boolValue {
                    if tap.view == nil {
                        self.view.addGestureRecognizer(tap)
                    }
                    tap.isEnabled = true
                }else{
                    tap.isEnabled = false
                }
            }
        }
    }
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
}

extension FXAlertController: FXStyleSetable { }
extension FXStyleSetting where TargetType: FXAlertController {
    ///遮罩层
    public static func cover(color:UIColor) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.backgroundView.backgroundColor = color
        })
    }
    ///遮罩层
    public static func cover(rgb color:UInt32) -> FXStyleSetting<TargetType> {
        return cover(color: UIColor(rgb: color))
    }
    ///间距
    public static func padding(_ padding:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.container.snp.updateConstraints { (make) in
                make.left.equalTo(target.backgroundView).offset(padding)
                make.right.equalTo(target.backgroundView).offset(-padding)
            }
        })
    }
    ///圆角
    public static func corner(_ radius:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.container.layer.cornerRadius = radius
        })
    }
    ///标题样式
    public static func title(_ styles: FXStyleSetting<UILabel>...) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            styles.forEach({$0.action(target.titleLabel)})
        })
    }
    ///按钮边距
    public static func button(padding: UIEdgeInsets) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            let buttons = target.buttonsView.subviews
            //两个按钮时横向并列，其他纵向并列
            if buttons.count > 2 {
                buttons[0].snp.updateConstraints { (make) in
                    make.top.equalTo(target.buttonsView).offset(padding.top)
                }
                buttons[buttons.count - 1].snp.updateConstraints { (make) in
                    make.bottom.equalTo(target.buttonsView).offset(-padding.bottom)
                }
                for btn in buttons {
                    btn.snp.updateConstraints { (make) in make.left.equalTo(target.buttonsView).offset(padding.left)
                        make.right.equalTo(target.buttonsView).offset(-padding.right)
                    }
                }
            }else if buttons.count > 1 {
                buttons[0].snp.updateConstraints { (make) in
                    make.left.equalTo(target.buttonsView).offset(padding.left)
                    make.top.equalTo(target.buttonsView).offset(padding.top)
                    make.bottom.equalTo(target.buttonsView).offset(-padding.bottom)
                }
                buttons[1].snp.updateConstraints { (make) in
                    make.right.equalTo(target.buttonsView).offset(-padding.right)
                    make.top.equalTo(target.buttonsView).offset(padding.top)
                    make.bottom.equalTo(target.buttonsView).offset(-padding.bottom)
                }
            }else{
                buttons[0].snp.updateConstraints { (make) in
                    make.left.equalTo(target.buttonsView).offset(padding.left)
                    make.right.equalTo(target.buttonsView).offset(-padding.right)
                    make.top.equalTo(target.buttonsView).offset(padding.top)
                    make.bottom.equalTo(target.buttonsView).offset(-padding.bottom)
                }
            }
        })
    }
    ///按钮间距
    public static func button(spacing: CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            let buttons = target.buttonsView.subviews
            //两个按钮时横向并列，其他纵向并列
            if buttons.count > 2 {
                for i in 0..<buttons.count-1 {
                    buttons[i + 1].snp.updateConstraints { (make) in
                        make.top.equalTo(buttons[i].snp.bottom).offset(spacing)
                    }
                }
            }else if buttons.count > 1 {
                buttons[1].snp.updateConstraints { (make) in
                    make.left.equalTo(buttons[0].snp.right).offset(spacing)
                }
            }
        })
    }
    ///所有按钮样式
    public static func button(_ styles: FXStyleSetting<UIButton>...) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            for idx in 0..<target.buttonsView.subviews.count {
                if let btn = target.buttonsView.subviews[idx] as? UIButton {
                    styles.forEach({$0.action(btn)})
                }
            }
            
        })
    }
    ///突出按钮样式
    public static func button(destructive styles: FXStyleSetting<UIButton>...) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let di = target.destructiveIndex, let btn = target.buttonsView.subviews[di] as? UIButton {
                styles.forEach({$0.action(btn)})
            }
        })
    }
    ///普通按钮样式
    public static func button(normal styles: FXStyleSetting<UIButton>...) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            for idx in 0..<target.buttonsView.subviews.count {
                if let di = target.destructiveIndex, di == idx {
                    continue
                }
                if let btn = target.buttonsView.subviews[idx] as? UIButton {
                    styles.forEach({$0.action(btn)})
                }
            }
            
        })
    }
    ///分割线颜色
    public static func separator(color: UIColor) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.buttonsView.backgroundColor = color
            target.separator.backgroundColor = color
        })
    }
    ///分割线颜色
    public static func separator(rgb color: UInt32) -> FXStyleSetting<TargetType> {
        return separator(color: UIColor(rgb: color))
    }
    ///分割线边距
    public static func separator(padding: CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.separator.snp.updateConstraints({ (make) in
                make.left.equalTo(target.container).offset(padding)
                make.right.equalTo(target.container).offset(-padding)
            })
        })
    }
}
