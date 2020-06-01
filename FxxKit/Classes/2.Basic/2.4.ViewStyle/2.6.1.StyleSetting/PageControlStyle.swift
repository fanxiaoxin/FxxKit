//
//  PagedControlStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/8.
//

import UIKit

extension FXStyleSetting where TargetType: UIPageControl {
    ///背景点颜色
    public static func color(_ color:UIColor?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageIndicatorTintColor = color
        })
    }
    ///背景点颜色
    public static func color(rgb color:UInt32) -> FXStyleSetting<TargetType> {
        return .color(UIColor(rgb: color))
    }
    ///选中点颜色
    public static func current(color:UIColor?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.currentPageIndicatorTintColor = color
        })
    }
    ///选中点颜色
    public static func current(rgb color:UInt32) -> FXStyleSetting<TargetType> {
        return .color(UIColor(rgb: color))
    }
    ///单页隐藏
    public static func hidesSingle(_ hides: Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.hidesForSinglePage = hides
        })
    }
    ///页数
    public static func pages(_ count: Int) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.numberOfPages = count
        })
    }
    ///当前页码
    public static func current(_ current: Int) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.currentPage = current
        })
    }
    
}
