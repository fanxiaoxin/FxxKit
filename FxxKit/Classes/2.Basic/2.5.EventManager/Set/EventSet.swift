//
//  EventSet.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

open class FXEventSet<Event: FXEventType>: FXEventSetType where Event: Equatable {
    public typealias EventType = Event
    public var managers: [FXEventManagerType] = []
    ///若该事件的管理器不存在则新建
    public func manager(for event:Event, allowNil: Bool) -> FXEventManagerType? {
        if let idx = self.findManager(for: event) {
            return self.managers[idx]
        }
        if allowNil {
            return nil
        }else{
            let m = FXEventManager(event: event)
            self.managers.append(m)
            return m
        }
    }
    public func didUnregisterEventHandler(for event: Event) {
        if let idx = self.findManager(for: event) {
            ///当删掉所有的Handler后，把这个事件的管理器也删除
            if (self.managers[idx] as? FXEventManager)?.handlers.count == 0 {
                self.managers.remove(at: idx)
            }
        }
    }
    func findManager(for event: Event) -> Int? {
        return self.managers.firstIndex { manager in
            if let e = manager.event as? EventType {
                return e == event
            }
            return true
        }
    }
}
