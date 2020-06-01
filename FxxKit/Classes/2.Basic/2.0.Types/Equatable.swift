//
//  Equatable.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/19.
//

import UIKit

///非泛型接口
public protocol FXEquatable {
    func isEqualTo(_ any:Any) -> Bool
}
extension FXEquatable where Self: Equatable {
    public func isEqualTo(_ any:Any) -> Bool {
        if let obj = any as? Self {
            return self == obj
        }
        return false
    }
}
extension NSObject: FXEquatable {}
