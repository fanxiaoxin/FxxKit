//
//  EventTriggerable.swift
//  Alamofire
//
//  Created by Fanxx on 2019/6/12.
//

import UIKit
public protocol FXEventTriggerable: FXEventSetType {
    var events: FXEventSet<EventType> { get }
}
extension FXEventTriggerable  {
    ///根据事件获取管理器
    public func manager(for event:EventType, allowNil:Bool) -> FXEventManagerType? {
        return self.events.manager(for: event, allowNil: allowNil)
    }
    ///当删除处理时发送一个通知
    public func didUnregisterEventHandler(for event:EventType) {
        self.events.didUnregisterEventHandler(for: event)
    }
}

extension FXEventTriggerable where Self: NSObject {
    public var events: FXEventSet<EventType> {
        if let events:FXEventSet<EventType> = self.fx.getAssociated(object:"fxEvents") {
            return events
        }else{
            let events = FXEventSet<EventType>()
            self.fx.setAssociated(object: events, key: "fxEvents")
            return events
        }
    }
}
