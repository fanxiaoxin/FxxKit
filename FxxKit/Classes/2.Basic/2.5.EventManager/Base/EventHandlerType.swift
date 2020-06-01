//
//  EventHandler.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

public protocol FXEventHandlerType {
    ///标识
    var identifier: String? { get }
    ///执行事件
    func execute(_ result:Any?)
}
extension FXEventManagerType {
    @discardableResult
    public static func += (left: Self, right: FXEventHandlerType) -> Int {
        return left.add(handler: right)
    }
    public static func -= (left: Self, right: String) {
        return left.remove(handler: right)
    }
}
