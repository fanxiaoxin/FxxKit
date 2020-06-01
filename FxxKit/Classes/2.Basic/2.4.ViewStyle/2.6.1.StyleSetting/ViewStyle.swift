//
//  ViewStyle.swift
//  FXKit
//
//  Created by Fanxx on 2019/5/31.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import YYCategories

extension FXStyleSetting where TargetType: UIView {
    ///背景色
    public static func bg(_ color:UIColor?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.backgroundColor = color
        })
    }
    ///背景色
    public static func bg(rgb color:UInt32) -> FXStyleSetting<TargetType> {
        return .bg(UIColor(rgb: color))
    }
    ///是否隐藏
    public static func hidden(_ hidden:Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isHidden = hidden
        })
    }
    ///透明度
    public static func alpha(_ alpha:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.alpha = alpha
        })
    }
    ///圆角
    public static func corner(_ radius:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.layer.cornerRadius = radius
            target.layer.masksToBounds = true
        })
    }
    ///边框
    public static func border(_ color: UIColor?, _ width: CGFloat = CGFloat.fx.pixel) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.layer.borderColor = color?.cgColor
            target.layer.borderWidth = width
        })
    }
    ///阴影
    public static func shadow(_ color:UIColor?,_  opactity:Float,_ offset: CGSize, _ radius: CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.layer.masksToBounds = false
            target.layer.shadowColor = color?.cgColor
            target.layer.shadowOpacity = opactity
            target.layer.shadowOffset = offset
            target.layer.shadowRadius = radius
        })
    }
    ///内容填充模式
    public static func content(mode:UIView.ContentMode) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.contentMode = mode
        })
    }
    ///变形
    public static func transform(rotation angle: CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * angle)
        })
    }
    ///变形
    public static func transform(scale x: CGFloat, _ y: CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.transform = CGAffineTransform(scaleX: x, y: y)
        })
    }
    ///变形
    public static func transform(translation x: CGFloat,_ y:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    public static func clips(_ clips:Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.clipsToBounds = clips
        })
    }
    ///是否可触发事件
    public static func triggerable(_ enabled:Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isUserInteractionEnabled = enabled
        })
    }
    
    public static func tag(_ tag:Int) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.tag = tag
        })
    }
    
    ///设置视图的高宽
    public static func size(_ width: CGFloat,_ height: CGFloat) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.snp.makeConstraints({ (make) in
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
        })
    }
    ///设置视图的高宽
    public static func size(_ widthHeight: CGFloat) -> FXStyleSetting<TargetType> {
        return self.size(widthHeight, widthHeight)
    }
    ///设置视图的高度
    public static func height(_ height: CGFloat) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.snp.makeConstraints({ (make) in
                make.height.equalTo(height)
            })
        })
    }
    ///设置视图的宽度
    public static func width(_ width: CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.snp.makeConstraints({ (make) in
                make.width.equalTo(width)
            })
        })
    }
    ///重新设置视图的高宽
    public static func newSize(width: CGFloat? = nil,height: CGFloat? = nil) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            if let w = width {
                target.snp.updateConstraints({ (make) in
                    make.width.equalTo(w)
                })
            }
            if let h = height {
                target.snp.updateConstraints({ (make) in
                    make.height.equalTo(h)
                })
            }
        })
    }
    ///设置视图的宽高比
    public static func aspect(ratio: CGFloat) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.snp.makeConstraints({ (make) in
                make.width.equalTo(target.snp.height).multipliedBy(ratio)
            })
        })
    }
    
    ///设置视图缩放优先级
    public static func priority(bigger value: UILayoutPriority, for axis:NSLayoutConstraint.Axis) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentHuggingPriority(value, for: axis)
        })
    }
    ///设置视图缩放优先级
    public static func priority(smaller value: UILayoutPriority, for axis:NSLayoutConstraint.Axis) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentCompressionResistancePriority(value, for: axis)
        })
    }
    ///设置视图缩放优先级
    public static func priority(_ value: UILayoutPriority, for axis:NSLayoutConstraint.Axis) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentHuggingPriority(value, for: axis)
            target.setContentCompressionResistancePriority(value, for: axis)
        })
    }
    ///设置视图缩放优先级
    public static func lowPriority(for axis:NSLayoutConstraint.Axis) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentHuggingPriority(.init(1), for: axis)
            target.setContentCompressionResistancePriority(.init(1), for: axis)
        })
    }
    ///设置视图缩放优先级
    public static func highPriority(for axis:NSLayoutConstraint.Axis) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentHuggingPriority(.init(999), for: axis)
            target.setContentCompressionResistancePriority(.init(999), for: axis)
        })
    }
    
    ///设置视图缩放优先级
    public static func priority(bigger value: UILayoutPriority) -> FXStyleSetting<TargetType>  {
         return .init(action: { (target) in
            target.setContentHuggingPriority(value, for: .horizontal)
            target.setContentHuggingPriority(value, for: .vertical)
        })
    }
    ///设置视图缩放优先级
    public static func priority(smaller value: UILayoutPriority) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentCompressionResistancePriority(value, for: .horizontal)
            target.setContentCompressionResistancePriority(value, for: .vertical)
        })
    }
    ///设置视图缩放优先级
    public static func priority(_ value: UILayoutPriority) -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentHuggingPriority(value, for: .horizontal)
            target.setContentCompressionResistancePriority(value, for: .horizontal)
            target.setContentHuggingPriority(value, for: .vertical)
            target.setContentCompressionResistancePriority(value, for: .vertical)
        })
    }
    ///设置视图缩放优先级
    public static func lowPriority() -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentHuggingPriority(.init(1), for: .horizontal)
            target.setContentCompressionResistancePriority(.init(1), for: .horizontal)
            target.setContentHuggingPriority(.init(1), for: .vertical)
            target.setContentCompressionResistancePriority(.init(1), for: .vertical)
        })
    }
    ///设置视图缩放优先级
    public static func highPriority() -> FXStyleSetting<TargetType>  {
        return .init(action: { (target) in
            target.setContentHuggingPriority(.init(999), for: .horizontal)
            target.setContentCompressionResistancePriority(.init(999), for: .horizontal)
            target.setContentHuggingPriority(.init(999), for: .vertical)
            target.setContentCompressionResistancePriority(.init(999), for: .vertical)
        })
    }
    ///颜色
       public static func tint(_ color:UIColor?) -> FXStyleSetting<TargetType> {
           return .init(action: { (target) in
               target.tintColor = color
           })
       }
       ///颜色
       public static func tint(rgb color:UInt32) -> FXStyleSetting<TargetType> {
           return .tint(UIColor(rgb: color))
       }
}
