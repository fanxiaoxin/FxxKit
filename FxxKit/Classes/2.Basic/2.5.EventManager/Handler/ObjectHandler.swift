//
//  ObjectHandler.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

open class FXObjectHandler: FXEventHandlerType {
    public var identifier: String?
    ///目标对象
    public weak var target: AnyObject?
    ///目标方法
    public var action: Selector
    public func execute(_ result: Any?) {
        let _ = target?.perform(self.action, with: result)
    }
    
    public init(_ identifier:String? = nil, target: AnyObject, action: Selector) {
        self.identifier = identifier
        self.target = target
        self.action = action
    }
}

extension FXEventManagerType {
    ///添加处理事件
    @discardableResult
    public func handle(_ identifier:String? = nil, target: AnyObject, action: Selector) -> Int {
        let handler = FXObjectHandler(identifier, target: target, action: action)
        return self.add(handler: handler)
    }
    ///添加处理事件
    @discardableResult
    public func handle(_ identifier:String? = nil, before: String, target: AnyObject, action: Selector) -> Int {
        let handler = FXObjectHandler(identifier, target: target, action: action)
        return self.add(handler: handler, before: before)
    }
    ///添加处理事件
    @discardableResult
    public func handle(_ identifier:String? = nil, after: String, target: AnyObject, action: Selector) -> Int {
        let handler = FXObjectHandler(identifier, target: target, action: action)
        return self.add(handler: handler, after: after)
    }
}

extension FXEventSetType {
    ///注册事件
    @discardableResult
    public func register(event:EventType, target:AnyObject, action: Selector, _ identifier:String? = nil) -> Int {
        return self.manager(for: event, allowNil: false)!.handle(identifier, target: target, action: action)
    }
}
