//
//  EventManager.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

public enum FXEvent: FXEventType {
    ///匿名事件
    case anonymous
}

///针对单一事件管理
open class FXEventManager: FXEventManagerType {
    ///事件类型
    public let event: FXEventType
    ///注册在该事件下的所有处理
    public internal(set) var handlers: [FXEventHandlerType] = []
    ///中断后续事件的处理，用于事件处理中中断使用，中断过后该值变为NO
    public var isAborting = false
    
    public init() {
        self.event = FXEvent.anonymous
    }
    public init(event:FXEventType) {
        self.event = event
    }
    ///添加事件处理
    @discardableResult
    open func add(handler:FXEventHandlerType) -> Int {
        var idx:Int = self.handlers.count
        self.safeAccessHandlers {
            self.handlers.append(handler)
            idx = self.handlers.count - 1
        }
        return idx
    }
    ///添加事件处理，若before为nil或找不到则插在最后面，若找到则插在该处理前面
    @discardableResult
    open func add(handler:FXEventHandlerType,before other:String) -> Int {
        var idx:Int = self.handlers.count
        self.safeAccessHandlers {
            if let i = self.handlers.firstIndex(where: { $0.identifier == other }) {
                self.handlers.insert(handler, at: i)
                idx = i
            }else{
                self.handlers.append(handler)
                idx = self.handlers.count - 1
            }
        }
        return idx
    }
    ///添加事件处理，若after为nil则插到最前面，若找不到则加到最后面，若找到则插在该处理后面
    @discardableResult
    open func add(handler:FXEventHandlerType,after other:String) -> Int {
        var idx:Int = self.handlers.count
        self.safeAccessHandlers {
            if let i = self.handlers.firstIndex(where: { $0.identifier == other }) {
                self.handlers.insert(handler, at: i + 1)
                idx = i + 1
            }else{
                self.handlers.append(handler)
                idx = self.handlers.count - 1
            }
        }
        return idx
    }
    ///移除事件，按索引
    open func remove(handler index:Int){
        self.safeAccessHandlers {
            _ = self.handlers.remove(at: index)
        }
    }
    ///移除事件，使用事件的id
    open func remove(handler identifier:String) {
        self.safeAccessHandlers {
            if let idx = self.handlers.firstIndex(where: { $0.identifier == identifier }) {
                _ = self.handlers.remove(at: idx)
            }
        }
    }
    ///移除所有事件
    open func removeAllHandlers() {
        self.safeAccessHandlers {
            self.handlers.removeAll()
        }
    }
    
    ///触发事件
    open func fire(_ result:Any?) {
        self.safeAccessHandlers {
            for handler in self.handlers {
                handler.execute(result)
                if self.isAborting {
                    self.isAborting = false
                    break
                }
            }
        }
    }
    ///中断事件处理
    open func abort()  {
        isAborting = true
    }
}
extension FXEventManager {
    ///移除所有该对象的处理
    public func remove(handler target:AnyObject) {
        self.safeAccessHandlers {
            var i = self.handlers.count - 1
            while i >= 0 {
                if let oh = self.handlers[i] as? FXObjectHandler {
                    if let t = oh.target, t === target {
                        self.handlers.remove(at: i)
                    }
                }
                i -= 1
            }
        }
    }
    ///移除处理
    public func remove(handler target:AnyObject, action: Selector) {
        self.safeAccessHandlers {
            var i = self.handlers.count - 1
            while i >= 0 {
                if let oh = self.handlers[i] as? FXObjectHandler {
                    if let t = oh.target, t === target, oh.action == action {
                        self.handlers.remove(at: i)
                    }
                }
                i -= 1
            }
        }
    }
}
