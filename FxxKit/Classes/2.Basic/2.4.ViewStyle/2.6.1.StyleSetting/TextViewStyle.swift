//
//  TextViewStyle.swift
//  FXKit
//
//  Created by Fanxx on 2019/8/12.
//

import UIKit

extension FXStyleSetting where TargetType: UITextView {
    ///文本
    public static func text(_ text:String?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.text = text
        })
    }
    ///富文本
    public static func text(_ text:NSAttributedString?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.attributedText = text
        })
    }
    ///富文本
    public static func attr(_ text:NSAttributedString?) -> FXStyleSetting<TargetType> {
        return self.text(text)
    }
    ///字体
    public static func font(_ font:UIFont?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.font = font
        })
    }
    ///系统字体
    public static var systemFont:FXStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: UIFont.systemFontSize))}
    ///系统字体
    public static func font(size: CGFloat) -> FXStyleSetting<TargetType> { return .font(UIFont.systemFont(ofSize: size))}
    ///系统字体
    public static func boldFont(size: CGFloat) -> FXStyleSetting<TargetType> { return .font(UIFont.boldSystemFont(ofSize: size))}
    
    ///文本颜色
    public static func color(_ color:UIColor?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textColor = color
        })
    }
    ///文本颜色
    public static func color(rgb color:UInt32) -> FXStyleSetting<TargetType> {
        return .color(UIColor(rgb: color))
    }
    ///对齐
    public static func align(_ align:NSTextAlignment) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textAlignment = align
        })
    }
    ///居中对齐
    public static var center: FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.textAlignment = .center
        })
    }
    ///键盘
    public static func keyboard(_ type:UIKeyboardType) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.keyboardType = type
        })
    }
}
