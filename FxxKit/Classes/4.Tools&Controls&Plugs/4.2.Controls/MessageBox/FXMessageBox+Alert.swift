//
//  MFMessageBox+Alert.swift
//  ManageFinances
//
//  Created by Fanxx on 16/7/8.
//  Copyright © 2016年 YinChengPai. All rights reserved.
//

import UIKit

extension FXMessageBox {
    //弹出框
    public class func alert(_ message:String,completion:(()->Void)?=nil) {
        self.alert(title:nil,message:message,completion:completion)
    }
    public class func alert(title:String?, message:String,completion:(()->Void)?=nil) {
        let label = self.createAlertLabel(message)
//        let view = self.wrapView(label)
        self.alert(title:title, view: label, buttons: ["确定"], destructiveIndex: 0) { _ in
            completion?()
            return true
        }
    }
    public class func alert(_ message:NSAttributedString,completion:(()->Void)?=nil) {
        self.alert(title:nil,message:message,completion:completion)
    }
    public class func alert(title:String?,message:NSAttributedString,completion:(()->Void)?=nil) {
        let label = self.createAlertLabel(nil)
        label.attributedText = message
//        let view = self.wrapView(label)
        self.alert(title:title, view: label, buttons: ["确定"], destructiveIndex: 0) { _ in
            completion?()
            return true
        }
    }
    public class func alert(_ message:String,buttons:[String],destructiveIndex:Int? = 0,action:((Int)->Void)? = nil){
        self.alert(title: nil, message: message, buttons: buttons, destructiveIndex: destructiveIndex, action: action)
    }
    public class func alert(title:String?,message:String,buttons:[String],destructiveIndex:Int? = 0,action:((Int)->Void)? = nil){
        let label = self.createAlertLabel(message)
//        let view = self.wrapView(label)
        self.alert(title:title, view: label, buttons: buttons, destructiveIndex: destructiveIndex,action: { i in
            action?(i)
            return true
        })
    }
    public class func alert(_ message:NSAttributedString,buttons:[String],destructiveIndex:Int? = 0,action:((Int)->Void)? = nil){
        self.alert(title: nil, message: message, buttons: buttons, destructiveIndex: destructiveIndex, action: action)
    }
    public class func alert(title:String?, message:NSAttributedString,buttons:[String],destructiveIndex:Int? = 0,action:((Int)->Void)? = nil){
        let label = self.createAlertLabel(nil)
        label.attributedText = message
//        let view = self.wrapView(label)
        self.alert(view: label, buttons: buttons, destructiveIndex: destructiveIndex,action: { i in
            action?(i)
            return true
        })
    }
    public class func confirm(_ message:String,action:@escaping (()->Void)) {
        self.confirm(title: nil, message: message, action: action)
    }
    public class func confirm(title:String?, message:String,action:@escaping (()->Void)) {
        self.alert(message, buttons: ["确定","取消"], destructiveIndex: 0) { (i) in
            if i == 0 {
                action()
            }
        }
    }
    public class func confirm(_ message:NSAttributedString,action:@escaping (()->Void)) {
        self.confirm(title: nil, message: message, action: action)
    }
    public class func confirm(title:String?, message:NSAttributedString,action:@escaping (()->Void)) {
        self.alert(message, buttons: ["确定","取消"], destructiveIndex: 0) { (i) in
            if i == 0 {
                action()
            }
        }
    }
    @discardableResult
    public class func input<TextField: UITextField>(_ message:String?,placeholder:String?,action:@escaping ((String?)->Bool)) -> TextField {
        return self.input(title: nil, message: message, placeholder: placeholder, action: action)
    }
    @discardableResult
    public class func input<TextField: UITextField>(title:String?, message:String?,placeholder:String?,action:@escaping ((String?)->Bool)) -> TextField {
        let label = self.createAlertLabel(message, minHeight: nil)
        label.font = label.font?.withBold()
        let input = TextField()
        input.placeholder = placeholder
        let contentView = UIView()
        contentView.addSubview(label)
        contentView.addSubview(input)
        contentView.fx.add(label, layout: .top(15), .marginX)
            .next(input, layout: .bottomTop)
            .parent(.marginX, .bottom)
        let view = self.wrapView(contentView)
        self.alert(title:title, view: view, buttons: ["确定","取消"], destructiveIndex: 0) { i in
            _ = input.resignFirstResponder()
            if i == 0 {
                return action(input.text)
            }
            return true
        }
        return input
    }
    public class func createAlertLabel(_ text:String?, minHeight: CGFloat? = 98) -> FXLabel{
        let label = FXLabel()
        label.text = text
        label.font = alertStylesheet.messageFont
        label.textColor = alertStylesheet.fontColor
        label.numberOfLines = 0
        label.textAlignment = .left
        label.padding = .fx(x: 5, y: 5)
        label.isUserInteractionEnabled = true
        if let height = minHeight {
            label.snp.makeConstraints({ (make) in
                make.height.greaterThanOrEqualTo(height)
            })
        }
        
        return label
    }
}

extension FXStyleSetting where TargetType: FXAlertController {
    ///标题样式
    public static func text(_ styles: FXStyleSetting<UILabel>...) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let label = target.contentView as? UILabel {
                styles.forEach({$0.action(label)})
            }
        })
    }
}
