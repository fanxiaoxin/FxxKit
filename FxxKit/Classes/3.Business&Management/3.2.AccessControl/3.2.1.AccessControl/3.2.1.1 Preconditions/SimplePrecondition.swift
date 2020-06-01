//
//  SimplePrecondition.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/26.
//

import UIKit

public class FXSimplePrecondition<IT,OT>: FXPrecondition<IT,OT> {
    var verfiyAction: ((@escaping (Bool)->Void)->Void)? = nil
    public init(_ action: @escaping (@escaping (Bool)->Void)->Void) {
        super.init()
        self.verfiyAction = action
    }
    public override func verify() {
        self.verfiyAction?(self.finished)
    }
}
extension FXPrecondition {
    public static func simple(action: @escaping (@escaping (Bool)->Void)->Void) -> FXSimplePrecondition<InputType, OutputType> {
        return FXSimplePrecondition<InputType,OutputType>(action)
    }
}

/*
class FXViewControllerSimplePrecondition : FXViewControllerPrecondition {
    var verfiyAction: (((Bool)->Void)->Void)? = nil
    public init(_ action: @escaping ((Bool)->Void)->Void) {
        super.init()
        self.verfiyAction = action
    }
    public override func verify() {
        self.verfiyAction?(self.finished)
    }
}
extension FXViewControllerPrecondition {
    public static func simple(action: @escaping ((Bool)->Void)->Void) -> FXViewControllerPrecondition {
        return FXViewControllerSimplePrecondition(action)
    }
}
 */
