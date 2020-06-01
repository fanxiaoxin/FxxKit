//
//  FXEventManagerType.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

public protocol FXEventManagerType {
    ///事件类型
    var event: FXEventType { get }
    ///添加事件处理
    @discardableResult
    func add(handler:FXEventHandlerType) -> Int
    ///添加事件处理，若before为nil或找不到则插在最后面，若找到则插在该处理前面
    @discardableResult
    func add(handler:FXEventHandlerType,before other:String) -> Int
    ///添加事件处理，若after为nil则插到最前面，若找不到则加到最后面，若找到则插在该处理后面
    @discardableResult
    func add(handler:FXEventHandlerType,after other:String) -> Int
    ///移除事件，按索引
    func remove(handler index:Int)
    ///移除事件，使用事件的id
    func remove(handler identifier:String)
    ///移除所有事件
    func removeAllHandlers()
    
    ///触发事件
    func fire(_ result:Any?)
    ///中断事件处理
    func abort()
}
extension FXEventManagerType{
    ///线程安全地访问handlers
    internal func safeAccessHandlers(_ block:()->Void) {
        objc_sync_enter(self)
        block()
        objc_sync_exit(self)
    }
}
