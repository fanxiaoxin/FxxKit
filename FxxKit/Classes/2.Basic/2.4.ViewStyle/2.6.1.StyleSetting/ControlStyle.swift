//
//  ControlStyle.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/16.
//

import UIKit
import YYCategories

extension FXStyleSetting where TargetType: UIControl {
    ///事件
    public static func event(_ target:Any?, _ action: Selector, for event: UIControl.Event = .touchUpInside) -> FXStyleSetting<TargetType> {
        return .init(action: { (obj) in
            obj.addTarget(target, action: action, for: event)
        })
    }
    ///事件
    public static func event(for event: UIControl.Event = .touchUpInside, block: @escaping (TargetType) -> Void) -> FXStyleSetting<TargetType> {
        return .init(action: { (obj) in
            obj.addBlock(for: event, block: { (obj) in
                block(obj as! TargetType)
            })
        })
    }
    ///事件
    public static func valueChanged(_ target:Any?, _ action: Selector) -> FXStyleSetting<TargetType> {
        return event(target, action, for: .valueChanged)
    }
    ///事件
    public static func valueChanged(block: @escaping (TargetType) -> Void) -> FXStyleSetting<TargetType> {
        return event(for: .valueChanged, block: block)
    }
}
