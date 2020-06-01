//
//  RejectTypePrecondition.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/5.
//

import UIKit

public class RejectTypePrecondition<IT: NSObject,OT>: FXPrecondition<IT,OT> {
    public let types: [AnyClass]
    public init(types: [AnyClass]) {
        self.types = types
        super.init()
    }
    public override func verify() {
        if let ip = self.input {
            if self.types.contains(where: { ip.isKind(of: $0) }) {
                return finished(false)
            }
        }
        finished(true)
    }
}

extension FXPrecondition where InputType: NSObject {
    public static func reject(_ types: AnyClass...) -> RejectTypePrecondition<InputType, OutputType> {
        return RejectTypePrecondition<InputType,OutputType>(types: types)
    }
}
