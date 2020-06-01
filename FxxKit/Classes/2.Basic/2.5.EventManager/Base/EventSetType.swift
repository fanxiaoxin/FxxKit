//
//  EventSetType.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

///事件集：管理多种事件
public protocol FXEventSetType {
    associatedtype EventType: FXEventType where EventType:Equatable
    ///根据事件获取管理器
    func manager(for event:EventType, allowNil:Bool) -> FXEventManagerType?
    ///当删除处理时发送一个通知
    func didUnregisterEventHandler(for event:EventType)
}
public extension FXEventSetType {
    ///发送事件
    func send(event:EventType, result: Any?) {
        self.manager(for: event, allowNil: true)?.fire(result)
    }
    ///注册事件
    @discardableResult
    func register(event:EventType, handle:FXEventHandlerType) -> Int {
        return self.manager(for: event, allowNil: false)!.add(handler: handle)
    }
    ///注销事件
    func unregister(event:EventType, handler index: Int) {
        self.manager(for: event, allowNil: false)!.remove(handler: index)
        self.didUnregisterEventHandler(for: event)
    }
    ///注销事件
    func unregister(event:EventType, handler identifier:String) {
        self.manager(for: event, allowNil: false)!.remove(handler: identifier)
        self.didUnregisterEventHandler(for: event)
    }
    ///注销事件
    func unregister(event:EventType) {
        self.manager(for: event, allowNil: false)!.removeAllHandlers()
        self.didUnregisterEventHandler(for: event)
    }
}
