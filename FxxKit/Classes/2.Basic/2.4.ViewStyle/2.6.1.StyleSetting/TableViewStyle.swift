//
//  TableViewStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/17.
//

import UIKit

extension FXStyleSetting where TargetType: UITableView {
    ///行高
    public static func row(height:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.rowHeight = height
            target.estimatedRowHeight = height
        })
    }
    ///自动行高
    public static func row(estimated height:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.estimatedRowHeight = height
            target.rowHeight = UITableView.automaticDimension
        })
    }
    ///分隔线样式
    public static func separator(_ style:UITableViewCell.SeparatorStyle? = nil, color:UIColor? = nil, insets: UIEdgeInsets? = nil) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            if let s = style { target.separatorStyle = s }
            if let s = color { target.separatorColor = s }
            if let s = insets { target.separatorInset = s }
        })
    }
    ///选择
    public static func selection(_ allows:Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.allowsSelection = allows
        })
    }
    ///选择
    public static func selection(multiple allows:Bool = true) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.allowsMultipleSelection = allows
        })
    }
    public static func header(_ view: UIView) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.tableHeaderView = view
        })
    }
    public static func footer(_ view: UIView) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.tableFooterView = view
        })
    }
    ///将底部置为空View，可清除多余的分隔线
    public static var emptyFooter: FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.tableFooterView = UIView()
        })
    }
    ///注册Cell缓存类型
    public static func cell(_ cls: AnyClass, identifier: String = "Default") -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.register(cls, forCellReuseIdentifier: identifier)
        })
    }
}
