//
//  OnceEvent.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

///只触发一次的事件，触发后马上移除所有的handler
open class FXOnceEventManager: FXEventManager {

    ///随时触发状态，默认false，当为true时每次新添加事件处理都马上触发并移除，每次调用fire方法后(若被中断则丢弃后续处理)该值为true，若不想后续即时触发需手动设为false
    public var isReadyToFire = false
    private var result:Any?
    
    open override func add(handler: FXEventHandlerType) -> Int {
        if self.isReadyToFire {
            handler.execute(self.result)
            return -1
        }else{
            return super.add(handler: handler)
        }
    }
    open override func add(handler: FXEventHandlerType, before other: String) -> Int {
        if self.isReadyToFire {
            handler.execute(self.result)
            return -1
        }else{
            return super.add(handler: handler, before: other)
        }
    }
    open override func add(handler: FXEventHandlerType, after other: String) -> Int {
        if self.isReadyToFire {
            handler.execute(self.result)
            return -1
        }else{
            return super.add(handler: handler, after: other)
        }
    }
    open override func fire(_ result:Any?) {
        self.isReadyToFire = true
        self.result = result
        self.safeAccessHandlers {
            while self.handlers.count > 0 {
                self.handlers.removeFirst().execute(result)
                if self.isAborting {
                    self.handlers.removeAll()
                    self.isAborting = false
                    break
                }
            }
        }
    }
    ///重置为未触发状态
    open func reset() {
        self.isReadyToFire = false
        self.result = nil
    }
}
