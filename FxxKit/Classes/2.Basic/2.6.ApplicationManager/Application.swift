//
//  ApplicationManager.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/4.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit

open class FXApplication {
    ///单例
    public static let shared = FXApplication()
    ///将构造函数私有化，仅限单例使用
    private init() { }

    private var __application: UIApplication?
    open var application: UIApplication {
        get{
            return __application ?? UIApplication.shared
        }
        ///如果Require Only App-Extension-Safe API是YES则需要手动设置
        set{
            __application = newValue
        }
    }
    public static var application: UIApplication {
        return shared.application
    }
    ///添加委托，需要系统的AppDelegate继承自FXApplicationDelegate
    open func add(delegate: UIApplicationDelegate) {
        if let fxd = application.delegate as? FXApplicationDelegate {
            if fxd.delegates != nil {
                fxd.delegates!.append(delegate)
            }else{
                fxd.delegates = [delegate]
            }
        }
    }
    ///移除委托
    open func remove(delegate: UIApplicationDelegate) {
        if let fxd = application.delegate as? FXApplicationDelegate {
            fxd.delegates?.removeAll(where: { $0 === delegate })
        }
    }
}
