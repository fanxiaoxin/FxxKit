//
//  StringAttributeShortcut.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/22.
//

import UIKit

extension FXStringAttribute {
    ///字体颜色
    public static func color(_ value: UIColor) -> FXStringAttribute {
        return .init(.foregroundColor, value)
    }
    ///字体颜色
    public static func color(rgb value: UInt32) -> FXStringAttribute {
        return .init(.foregroundColor, UIColor(rgb: value))
    }
    ///背景颜色
    public static func bg(_ color: UIColor) -> FXStringAttribute {
        return .init(.backgroundColor, color)
    }
    ///背景颜色
    public static func bg(rgb value: UInt32) -> FXStringAttribute {
        return .init(.backgroundColor, UIColor(rgb: value))
    }
    ///字体
    public static func font(_ value: UIFont) -> FXStringAttribute {
        return .init(.font, value)
    }
    ///字体
    public static func font(size: CGFloat) -> FXStringAttribute {
        return .init(.font, UIFont.systemFont(ofSize: size))
    }
    ///字体
    public static func boldFont(size: CGFloat) -> FXStringAttribute {
        return .init(.font, UIFont.boldSystemFont(ofSize: size))
    }
    ///是否包含连字符
    public static func ligature(_ value: Bool = true) -> FXStringAttribute {
        return .init(.ligature, value)
    }
    ///字距
    public static func kern(_ value: CGFloat) -> FXStringAttribute {
        return .init(.kern, value)
    }
    ///删除线
    public static func strikethrough(_ value: NSUnderlineStyle) -> FXStringAttribute {
        return .init(.strikethroughStyle, value)
    }
    ///下划线
    public static func underline(_ value: NSUnderlineStyle,_ color: UIColor? = nil) -> FXStringAttribute {
        var attr: [NSAttributedString.Key: Any] = [.underlineStyle: value]
        if let c = color {
            attr[.underlineColor] = c
        }
        return .init(attr)
    }
    ///下划线
    public static func underline(_ value: NSUnderlineStyle,rgb color: UInt32) -> FXStringAttribute {
        return underline(value, UIColor(rgb: color))
    }
    ///描边
    public static func stroke(_ color: UIColor, _ width: CGFloat) -> FXStringAttribute {
        return .init([.strokeColor:color, .strokeWidth: width])
    }
    ///描边
    public static func stroke(rgb color: UInt32, _ width: CGFloat) -> FXStringAttribute {
        return .init([.strokeColor:UIColor(rgb: color), .strokeWidth: width])
    }
    ///阴影
    public static func shadow(_ value: NSShadow) -> FXStringAttribute {
        return .init(.shadow, value)
    }
    ///阴影
    public static func shadow(offset: CGSize, radius: CGFloat, color: UIColor? = nil) -> FXStringAttribute {
        let shadow = NSShadow()
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = radius
        if let c = color {
            shadow.shadowColor = c
        }
        return .init(.shadow, shadow)
    }
    ///阴影
    public static func textEffect(_ style: NSAttributedString.TextEffectStyle) -> FXStringAttribute {
        return .init(.textEffect, style)
    }
    ///附件
    public static func attachment(_ value: NSTextAttachment) -> FXStringAttribute {
        return .init(.attachment, value)
    }
    ///链接
    public static func link(_ url: NSURL) -> FXStringAttribute {
        return .init(.link, url)
    }
    ///链接
    public static func link(_ url: String) -> FXStringAttribute {
        return .init(.link, url)
    }
    ///基准线偏移
    public static func baseline(offset: CGFloat) -> FXStringAttribute {
        return .init(.baselineOffset, offset)
    }
    ///段落样式
    public static func paragraph(style: NSParagraphStyle) -> FXStringAttribute {
        return .init(.paragraphStyle, style)
    }
}
