//
//  TextFieldStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/8.
//

import UIKit

extension FXStyleSetting where TargetType: UITextField {
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
    ///占位文本
    public static func placeholder(_ text:String?, color: UIColor? = nil) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if color == nil {
                target.placeholder = text
            }else if let t = text {
                var attr: [NSAttributedString.Key: Any] = [:]
                if let c = color {
                    attr[.foregroundColor] = c
                }
                let at = NSAttributedString(string: t, attributes: attr)
                target.attributedPlaceholder = at
            }
        })
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

    ///字体最小比例
    public static func min(scale:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.adjustsFontSizeToFitWidth = false
            target.minimumFontSize = scale
        })
    }
    ///字体最小尺寸
    public static func min(size:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.adjustsFontSizeToFitWidth = true
            target.minimumFontSize = size
        })
    }
    ///清除模式
    public static func clear(model:UITextField.ViewMode = .whileEditing) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.clearButtonMode = model
        })
    }
    ///是否隐藏输入，默认true
    public static func secure(_ secure:Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isSecureTextEntry = secure
        })
    }
    ///键盘
    public static func keyboard(_ type:UIKeyboardType) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.keyboardType = type
        })
    }
}
