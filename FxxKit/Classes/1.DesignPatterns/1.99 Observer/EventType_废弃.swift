//
//  EventEnumType.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//
/*
import Foundation

///事件类型
public protocol FXEventType {
    
}
public protocol FXEqualbeEventType: FXEventType, Equatable {
    
}

///可自定义事件
public protocol FXEventCustomizableType: FXEqualbeEventType {
    init<EventType: FXEqualbeEventType>(custom:EventType)
    func custom<EventType: FXEqualbeEventType>() -> EventType?
}
///自定义操作符便捷转换自定义事件
prefix operator !
public prefix func !<T:FXEventCustomizableType,ET:FXEqualbeEventType> (type: ET) -> T {
    return T(custom: type)
}
*/
/*
 使用方式: let event: EVENT_TYPE = !CUSTOM_EVENT_TYPE.EVENT
 if let customEvent:CUSTOM_EVENT_TYPE = event.custom() {
 switch customEvent {
 ...CUSTOM_EVENT_TYPE cases
 }
 }
 */

