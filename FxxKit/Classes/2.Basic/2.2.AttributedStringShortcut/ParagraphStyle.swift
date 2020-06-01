//
//  ParagraphStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/22.
//

import UIKit

public enum FXParagraphStyleSetter {
    case lineSpacing(CGFloat)
    case paragraphSpacing(CGFloat)
    case alignment(NSTextAlignment)
    case firstLineHeadIndent(CGFloat)
    case headIndent(CGFloat)
    case tailIndent(CGFloat)
    case lineBreak(NSLineBreakMode)
    case minLineHeight(CGFloat)
    case maxLineHeight(CGFloat)
    case direction(NSWritingDirection)
    case lineHeight(multiple:CGFloat)
    case paragraphSpacingBefore(CGFloat)
    case hyphenationFactor(Float)
    case tabStops([NSTextTab])
    case tab(interval:CGFloat)
    ///默认紧缩截断
    @available(iOS 9.0, *)
    case tighteningTruncation(Bool)
    @available(iOS 9.0, *)
    case add(tabStop:NSTextTab)
    @available(iOS 9.0, *)
    case remove(tabStop:NSTextTab)
    @available(iOS 9.0, *)
    case style(NSParagraphStyle)
}
extension FX.NamespaceImplement where Base: NSMutableParagraphStyle {
    public func apply(setter: FXParagraphStyleSetter) {
        switch setter {
        case let .lineSpacing(value): self.base.lineSpacing = value
        case let .paragraphSpacing(value): self.base.paragraphSpacing = value
        case let .alignment(value): self.base.alignment = value
        case let .firstLineHeadIndent(value): self.base.firstLineHeadIndent = value
        case let .headIndent(value): self.base.headIndent = value
        case let .tailIndent(value): self.base.tailIndent = value
        case let .lineBreak(value): self.base.lineBreakMode = value
        case let .minLineHeight(value): self.base.minimumLineHeight = value
        case let .maxLineHeight(value): self.base.maximumLineHeight = value
        case let .direction(value): self.base.baseWritingDirection = value
        case let .lineHeight(multiple:value): self.base.lineHeightMultiple = value
        case let .paragraphSpacingBefore(value): self.base.paragraphSpacingBefore = value
        case let .hyphenationFactor(value): self.base.hyphenationFactor = value
        case let .tabStops(value): self.base.tabStops = value
        case let .tab(interval:value): self.base.defaultTabInterval = value
        ///默认紧缩截断
        case let .tighteningTruncation(value):
            if #available(iOS 9.0, *) {
                self.base.allowsDefaultTighteningForTruncation = value
            }
        case let .add(tabStop:value):
            if #available(iOS 9.0, *) {
                self.base.addTabStop(value)
            }
        case let .remove(tabStop:value):
            if #available(iOS 9.0, *) {
                self.base.removeTabStop(value)
            }
        case let .style(value):
            if #available(iOS 9.0, *) {
                self.base.setParagraphStyle(value)
            }
        }
    }
}
extension FXStringAttribute {
    ///段落样式
    public static func paragraph(_ setters: FXParagraphStyleSetter...) -> FXStringAttribute {
        let value = NSMutableParagraphStyle()
        setters.forEach({ value.fx.apply(setter: $0) })
        return .init(.paragraphStyle, value)
    }
}
