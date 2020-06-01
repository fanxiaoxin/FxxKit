//
//  Weaker.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/19.
//

import UIKit

///用于保存弱对象
public struct FXWeaker {
    public weak var obj: AnyObject?
}

///保存弱对象，并在对象销毁时自动清除对象
open class FXWeakerSet {
    private var weakers: [FXWeaker] = []
    public init() {
        
    }
    ///添加对象
    open func append(_ obj: AnyObject) {
        self.checkObjectsAliving()
        let weaker = FXWeaker(obj: obj)
        self.weakers.append(weaker)
    }
    ///检查对象是否存在，若不存在则移除
    open func checkObjectsAliving() {
        self.weakers.removeAll(where: { $0.obj == nil })
    }
    ///循环操作对象
    open func forEach<ObjectType>(_ body: (ObjectType) throws -> Void) rethrows {
        self.checkObjectsAliving()
        try self.weakers.map( { $0.obj as! ObjectType }).forEach(body)
    }
}
