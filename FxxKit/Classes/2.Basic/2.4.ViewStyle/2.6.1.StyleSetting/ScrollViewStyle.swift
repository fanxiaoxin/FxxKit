//
//  ScrollViewStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/8.
//

import UIKit

extension FXStyleSetting where TargetType: UIScrollView {
    ///边距
    public static func inset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        })
    }
    ///边距
    public static func inset(_ edgeInsets: UIEdgeInsets) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.contentInset = edgeInsets
        })
    }
    ///显示滚动条
    public static func indicator(vertical: Bool = true, horizontal: Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.showsVerticalScrollIndicator = vertical
            target.showsHorizontalScrollIndicator = horizontal
        })
    }
    ///显示滚动条
    public static func indicator(_ shows: Bool) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.showsVerticalScrollIndicator = shows
            target.showsHorizontalScrollIndicator = shows
        })
    }
    ///翻页开关
    public static func paging(_ enabled: Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isPagingEnabled = enabled
        })
    }
    public static func bounce(_ bounce: Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.bounces = bounce
        })
    }
    public static func bounce(vertical: Bool = true, horizontal: Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.alwaysBounceVertical = vertical
            target.alwaysBounceHorizontal = horizontal
        })
    }
    ///偏移量
    public static func offset(_ contentOffset: CGPoint, animated: Bool = false) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setContentOffset(contentOffset, animated: animated)
        })
    }
    ///偏移量
    public static func offset(x: CGFloat = 0,y:CGFloat = 0, animated: Bool = false) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.setContentOffset(CGPoint(x: x, y: y), animated: animated)
        })
    }
    ///缩放开关
    public static func zoom(_ bouncesZoom: Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.bouncesZoom = bouncesZoom
        })
    }
    ///是否可滚动
    public static func enabled(_ enabled: Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.isScrollEnabled = enabled
        })
    }
    
    ///委托
    public static func delegate(_ delegate: UIScrollViewDelegate) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.delegate = delegate
        })
    }
}
