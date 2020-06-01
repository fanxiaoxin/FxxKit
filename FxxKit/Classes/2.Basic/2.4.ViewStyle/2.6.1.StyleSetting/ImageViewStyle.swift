//
//  ImageViewStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/15.
//

import UIKit
import YYCategories

extension FXStyleSetting where TargetType: UIImageView {
    ///图片
    public static func image(_ image:UIImage?, tint color: UIColor? = nil) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let c = color {
                target.image = image?.byTintColor(c)
            }else{
                target.image = image
            }
        })
    }
    ///图片
    public static func image(_ named:String, tint color: UIColor? = nil) -> FXStyleSetting<TargetType> {
        return image(UIImage(named: named), tint: color)
    }
    ///图片
    public static func highlighted(image:UIImage?, tint color: UIColor? = nil) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let c = color {
                target.highlightedImage = image?.byTintColor(c)
            }else{
                target.highlightedImage = image
            }
        })
    }
    ///图片
    public static func highlighted(image named:String, tint color: UIColor? = nil) -> FXStyleSetting<TargetType> {
        return highlighted(image:UIImage(named: named), tint: color)
    }
    
    ///图片变色
    public static func tint(color:UIColor) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.image = target.image?.byTintColor(color)
        })
    }
    ///图片变色
    public static func tint(rgbColor:UInt32) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.image = target.image?.byTintColor(UIColor(rgb: rgbColor))
        })
    }
    
    ///图片变形
    public static func resizable(_ insets:UIEdgeInsets) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.image = target.image?.resizableImage(withCapInsets: insets)
            target.contentMode = .scaleToFill
        })
    }
    ///图片变形
    public static func resizable(_ top: CGFloat, _ left: CGFloat,_ bottom: CGFloat, _ right: CGFloat) -> FXStyleSetting<TargetType> {
        return resizable(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    ///旋转图片图片
    public static func rotate(_ degrees:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let img = target.image {
                let r = img.byRotate(DegreesToRadians(degrees), fitSize: true)
                target.image = r
            }
        })
    }
    ///旋转图片图片
    public static func rotate(highlighted degrees:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let img = target.highlightedImage {
                let r = img.byRotate(DegreesToRadians(degrees), fitSize: true)
                target.highlightedImage = r
            }
        })
    }
}
