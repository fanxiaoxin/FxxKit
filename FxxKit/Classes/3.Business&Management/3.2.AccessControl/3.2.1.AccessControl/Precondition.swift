//
//  Authority.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/29.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation

///授权委托
public protocol FXPreconditionDelegate: AnyObject {
    ///授权完成
    func fxPrecondition(_ precondition:Any, passed:Bool)
}
///代表一个权限
open class FXPrecondition<InputType,OutputType>  {
    ///鉴权成功操作
    public var successHandler: (() -> Void)?
    ///鉴权失败操作
    public var failureHandler: (() -> Void)? {
        didSet {
            self.previous?.failureHandler = self.failureHandler
        }
    }
    ///当有自定义失败处理时是否依旧执行默认的失败处理
    public var isDefaultFailureActionPerformWhenHandled = true
    ///当有自定义成功处理时是否依旧执行默认的成功处理
    public var isDefaultSuccessActionPerformWhenHandled = true
    ///传入的参数
    public var input: InputType?
    ///测试通过的权限结果(如果有多种权限)，例：只读，修改，等等，仅在success时可使用
    public var output: OutputType?
    ///上一个前置条件
    public private(set) var previous:FXPrecondition<InputType,OutputType>?
    
    ///委托
    public weak var delegate: FXPreconditionDelegate?
    public init() {
        self.previous = self.previousPrecondition()
        self.previous?.successHandler = { [weak self] in self?.verify() }
    }
    open func previousPrecondition() -> FXPrecondition<InputType,OutputType>? {
        return nil
    }
    ///鉴权判断，子类应继承该方法来执行判断，完成后需调用finished方法，外部不该调用
    open func verify() {
        self.finished(true)
    }
    ///鉴权判断，外部应调用该方法
    public func check(_ input:InputType? = nil) {
        self.input = input
        ///优先检查上一个，成功后再判断自身
        if let pv = self.previous {
            pv.check(input)
        }else{
            self.verify()
        }
    }
    ///成功操作，重载可定制默认操作
    open func successAction()  {
        
    }
    ///失败操作，重载可定制默认操作
    open func failureAction() {
        
    }
    ///在子类判断完成后调用
    open func finished(_ passed:Bool) {
        if passed {
            if let s = self.successHandler {
                if self.isDefaultSuccessActionPerformWhenHandled {
                    self.successAction()
                }
                s()
            }else {
                self.successAction()
            }
        }else{
            if let f = self.failureHandler {
                if self.isDefaultFailureActionPerformWhenHandled {
                    self.failureAction()
                }
                f()
            }else {
                self.failureAction()
            }
        }
        self.delegate?.fxPrecondition(self, passed: passed)
    }
}
extension FXPrecondition {
    ///成功操作，注意如果鉴权是同步的则该方法须在check之前调用才有效
    @discardableResult
    public func pass(_ handler:@escaping () -> Void) -> Self {
        self.successHandler = handler
        return self
    }
    ///失败操作，注意如果鉴权是同步的则该方法须在check之前调用才有效
    @discardableResult
    public func failure(_ handler:@escaping () -> Void) -> Self {
        self.failureHandler = handler
        return self
    }
    ///鉴权判断
    @discardableResult
    public func check(_ input:InputType? = nil, success handler:@escaping () -> Void) -> Self {
        self.successHandler = handler
        self.check(input)
        return self
    }
}
