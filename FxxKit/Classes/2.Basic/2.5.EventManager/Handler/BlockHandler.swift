//
//  actionHandler.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

open class FXBlockHandler<ResultType>: FXEventHandlerType {
    public var identifier: String?
    public var action: (ResultType?)->Void
    
    public func execute(_ result: Any?) {
        self.action(result as? ResultType)
    }
    public init(_ identifier:String? = nil, action: @escaping (ResultType?) ->Void) {
        self.identifier = identifier
        self.action = action
    }
}

extension FXEventManagerType {
    ///添加处理事件
    @discardableResult
    public func handle(_ identifier:String? = nil, action:@escaping ()->Void) -> Int{
        let handler = FXBlockHandler<Any>(identifier, action: { _ in
            action()
        })
        return self.add(handler: handler)
    }
    ///添加处理事件
    @discardableResult
    public func handle<ResultType>(_ identifier:String? = nil, action:@escaping (ResultType?)->Void) -> Int{
        let handler = FXBlockHandler(identifier, action: action)
        return self.add(handler: handler)
    }
    ///添加处理事件
    @discardableResult
    public func handle<ResultType>(_ identifier:String? = nil, before other:String, action:@escaping (ResultType?)->Void) -> Int {
        let handler = FXBlockHandler(identifier, action: action)
        return self.add(handler: handler, before: other)
    }
    ///添加处理事件
    @discardableResult
    public func handle<ResultType>(_ identifier:String? = nil, after other:String, action:@escaping (ResultType?)->Void) -> Int {
        let handler = FXBlockHandler(identifier, action: action)
        return self.add(handler: handler, after: other)
    }
//    @discardableResult
//    public static func += <EventType> (left: Event, right: @escaping (EventType) -> Void) -> actionHandler<EventType> {
//        return left.handle(right)
//    }
}

extension FXEventSetType {
    ///注册事件
    @discardableResult
    public func register<ResultType>(event:EventType, identifier:String? = nil,action:@escaping (ResultType?)->Void) -> Int {
        return self.manager(for: event, allowNil: false)!.handle(identifier, action: action)
    }
    ///注册事件
    @discardableResult
    public func register(event:EventType, identifier:String? = nil,action:@escaping ()->Void) -> Int {
        return self.manager(for: event, allowNil: false)!.handle(identifier, action: action)
    }
}
