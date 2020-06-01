//
//  FlowController.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/26.
//

import UIKit

public protocol FXFlowControllerType: FXViewControllerType {
    var onFlow: ((FXFlowStep.State) -> Void)? { get set }
}
open class FXControllerFlow: FXFlow {
    open var controller: UIViewController?
    public override var flow: FXFlow? {
        didSet {
            if self.controller == nil {
                if let f = self.flow as? FXControllerFlow {
                    self.controller = f.controller
                }
            }
        }
    }
    public init(_ controller: FXFlowControllerType? = nil) {
        self.controller = controller
        super.init()
    }
}
open class FXControllerFlowStep: FXFlowStep {
    public var controller: FXFlowControllerType? {
        didSet {
            self.setControllerFlowAction()
        }
    }
    func setControllerFlowAction() {
        self.controller?.onFlow = { [weak self] state in
            self?.state = state
            ///若是结束则将onFlow置为空，防止二次调用
            if state.isFinished {
                self?.controller?.onFlow = nil
            }
        }
    }
    public init(_ controller: FXFlowControllerType?) {
        self.controller = controller
        super.init()
        self.setControllerFlowAction()
    }
    open override func action() {
        if let c = self.controller {
            (self.flow as? FXControllerFlow)?.controller?.load(c)
        }else{
            self.state = .success
        }
    }
}
extension FXFlow {
    @discardableResult
    open func branch(_ controller: FXFlowControllerType, for state: State...) -> Self {
        let step = FXControllerFlowStep(controller)
        step.trigerStates = state
        return self.branch(step)
    }
    @discardableResult
    open func next(_ controller: FXFlowControllerType, for state: State...) -> Self {
        let step = FXControllerFlowStep(controller)
        step.trigerStates = state
        return self.next(step)
    }
}
