//
//  Timer.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

open class FXTimer: FXEventManager {
    ///间隔，默认1秒
    public var interval: TimeInterval = 1
    ///使用间隔初始化
    public init(interval:TimeInterval) {
        self.interval = interval
        super.init()
    }
    ///是否在开启时马上执行
    public var isExecuteOnFire = false
    ///是否在无可处理时自动停止，若是启用了该选项，则在自动停止而非手动停止后可在添加处理后自动启动，但若是自动停止后调用过stop方法则不会再自动启动
    public var isAutoStopWhenEmpty = false
    ///添加处理的时候自动启动
    public var isAutoStartWhenHandled = false
    ///委托
//    public weak var delegate : TimerDelegate?
    ///最后执行的时间
    public private(set) var lastFireTime: Date? = nil
    
    private var timer: Timer? = nil
    private var isAutoStoping = false
    
    //是否正在计时,计时中也可往里面加处理
    public var isRunning: Bool {
        return timer?.isValid ?? false
    }
    //开始
    open func start() {
        if self.tryAutoStop() {
            return
        }
        if self.isExecuteOnFire {
            self.fire(nil)
        }
        if !self.isRunning {
            self.startTimer()
        }
    }
    //结束
    open func stop() {
        self.isAutoStoping = false
        if self.isRunning {
            self.stopTimer()
        }
    }
    func startTimer() {
        self.lastFireTime = Date()
        timer = Timer(timeInterval: self.interval, target: self, selector: #selector(self.run), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    func stopTimer() {
        if let t = timer {
            t.invalidate()
            timer = nil
        }
    }
    @objc func run() {
        if !self.tryAutoStop() {
            self.lastFireTime = Date()
            self.fire(nil)
        }
    }
    @discardableResult func tryAutoStop() -> Bool {
        if self.isAutoStopWhenEmpty && self.handlers.count == 0 {
            self.stop()
            self.isAutoStoping = true
            return true
        }
        return false
    }
    @discardableResult func tryAutoStart() -> Bool {
        if self.isRunning {
            return false
        }
        if (self.isAutoStartWhenHandled || self.isAutoStoping) && self.handlers.count > 0 {
            //马上执行
            if self.isExecuteOnFire {
                self.fire(nil)
            }
            self.startTimer()
            self.isAutoStoping = false
            return true
        }
        return false
    }
    func whenAdd() {
        self.tryAutoStart()
    }
    func whenRemove() {
        self.tryAutoStop()
    }
    open override func add(handler: FXEventHandlerType) -> Int {
        let r = super.add(handler: handler)
        self.whenAdd()
        return r
    }
    open override func add(handler: FXEventHandlerType, before other: String) -> Int {
        let r = super.add(handler: handler, before: other)
        self.whenAdd()
        return r
    }
    open override func add(handler: FXEventHandlerType, after other: String) -> Int {
        let r = super.add(handler: handler, after: other)
        self.whenAdd()
        return r
    }
    open override func remove(handler index: Int) {
        super.remove(handler: index)
        self.whenRemove()
    }
    open override func remove(handler identifier: String) {
        super.remove(handler: identifier)
        self.whenRemove()
    }
    
    open override func removeAllHandlers() {
        super.removeAllHandlers()
        self.whenRemove()
    }
}
