//
//  FlowCenter.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/8.
//

import UIKit

open class FXFlowCenter: FXFlow {
    public typealias Queue = Int
    public static let mainQueue: Queue = 0
    private static var flowCenters:[FXFlowCenter] = []
    //添加流程进队列并排队启动
    @discardableResult
    public static func add(_ FXFlow: FXFlow, queue: Queue = mainQueue) -> Bool {
        let flowCenter: FXFlowCenter
        if let fc = flowCenters.first(where: { $0.queue == queue }) {
            flowCenter = fc
        }else{
            flowCenter = FXFlowCenter(queue)
            flowCenters.append(flowCenter)
        }
        flowCenter.next(FXFlow)
        //若正在跑也不会重复执行，但执行完会执行下一步
        return flowCenter.start()
    }
    ///特殊流程，可重复触发
    open override func doAction() -> Bool {
        self.isTriggered = false
        return super.doAction()
    }
    
    private let queue: Queue
    private init(_ queue: Queue) {
        self.queue = queue
        super.init()
    }
}
extension FXFlow {
    ///放入执行队列
    public func activate(queue: FXFlowCenter.Queue = FXFlowCenter.mainQueue) {
        FXFlowCenter.add(self, queue: queue)
    }
}
