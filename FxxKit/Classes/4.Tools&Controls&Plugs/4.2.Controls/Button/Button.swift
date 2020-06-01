//
//  Button.swift
//  FXKit
//
//  Created by Fanxx on 2019/7/11.
//

import UIKit

open class FXButton: UIButton {
    ///图片位置
    open var imagePosition: FXDirection = .left
    ///下划线宽度
    open var underlineWidth: CGFloat = 0
    ///下划线颜色
    open var underlineColor: UIColor? = nil
    
    func currentUnderlineColor() -> UIColor? {
        return self.underlineColor ?? self.currentTitleColor
    }
    func currentImagePlaceholder() -> CGSize {
        return CGSize(width: (self.currentImage?.size.width ?? 0) + self.imageEdgeInsets.left + self.imageEdgeInsets.right,
                      height: (self.currentImage?.size.height ?? 0) + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom)
    }
    func titleSize(for contentSize: CGSize) -> CGSize {
        var size = contentSize
        size.width -= self.titleEdgeInsets.left + self.titleEdgeInsets.right;
        size.height -= self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
        if self.imagePosition.in(.left, .right) {
            size.width -= self.currentImagePlaceholder().width;
        }
        return self.titleLabel?.sizeThatFits(size) ?? .zero
    }
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imgSize = self.currentImagePlaceholder()
        var rect = super.titleRect(forContentRect: contentRect)
        switch self.imagePosition {
        case .top:
            var cr = contentRect
            cr.size.width  += imgSize.width
            rect.size.width = super.titleRect(forContentRect: cr).width
            rect.origin.x -= imgSize.width / 2
            rect.origin.y += imgSize.height / 2
        case .bottom:
            var cr = contentRect
            cr.size.width  += imgSize.width
            rect.size.width = super.titleRect(forContentRect: cr).width
            rect.origin.x -= imgSize.width / 2
            rect.origin.y -= imgSize.height / 2
            if let size = self.titleLabel?.sizeThatFits(rect.size) {
                rect.size = size
            }
        case .right:
            rect.origin.x -= imgSize.width
        default: break
        }
        return rect
    }
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleSize = self.titleSize(for: contentRect.size)
        var rect = super.imageRect(forContentRect: contentRect)
        switch self.imagePosition {
        case .top:
            rect.origin.x += titleSize.width / 2
            rect.origin.y -= titleSize.height / 2
        case .bottom:
            rect.origin.x += titleSize.width / 2
            rect.origin.y += titleSize.height / 2
        case .right:
            rect.origin.x += titleSize.width;
        default: break
        }
        return rect
    }
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
//        let imgSize = self.currentImagePlaceholder()
//        switch self.imagePosition {
//        case .top,.bottom:
//            size.width -= imgSize.width
//            size.height += imgSize.height
//        default: break
//        }
        
        size.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right
        switch self.imagePosition {
        case .left, .right:
            size.width += self.imageEdgeInsets.left + self.imageEdgeInsets.right
        default:
            break
        }
        return size
    }
    open override func draw(_ rect: CGRect) {
        if (self.underlineWidth > 0) {
            let textRect = self.titleLabel?.frame ?? .zero
            if let context = UIGraphicsGetCurrentContext(), let color = self.currentUnderlineColor() {
                let descender = self.titleLabel?.font.descender ?? 0
                context.setStrokeColor(color.cgColor)
                context.move(to: CGPoint(x: textRect.origin.x, y: textRect.origin.y + textRect.size.height + descender+1))
                context.addLine(to: CGPoint(x: textRect.origin.x + textRect.size.width, y: textRect.origin.y + textRect.size.height + descender+1))
                
                context.closePath()
                context.drawPath(using: .stroke)
            }
        }
    }
}

extension FXBuildable where Self: UIView {
    public static func fxButton(_ styles: FXStyleSetting<FXButton>...) -> FXButton {
        return FXButton().fx(styles: styles)
    }
}

extension FXStyleSetting where TargetType: FXButton {
    ///下划线
    public static func underline(_ color:UIColor? = nil, width: CGFloat = 1) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.underlineColor = color
            target.underlineWidth = width
        })
    }
    ///下划线
    public static func underline(rgb color:UInt32, width: CGFloat = 1) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.underlineColor = UIColor(rgb:color)
            target.underlineWidth = width
        })
    }
    ///图片位置
    public static func image(position:FXDirection) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.imagePosition = position
        })
    }
}
