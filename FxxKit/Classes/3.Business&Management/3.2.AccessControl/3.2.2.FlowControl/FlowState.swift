//
//  FlowState.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/7.
//

import UIKit

///单个流程
extension FXFlowStep {
    ///单个流程状态
    public enum State: Equatable {
        ///开始
        case begin
        ///处理中
        case processing
        ///失败(结束)
        case failure
        ///成功(结束)
        case success
        ///跳过(结束)
        case skip
        ///取消(结束)
        case cancel
        ///自定义状态，用于扩展
        case status(Int)
        ///是否已结束
        public var isFinished : Bool {
            return self.in(.failure, .success, .skip, .cancel)
        }
    }
}
