//
//  Direction.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/19.
//

import UIKit

///方向，可多选
public struct FXDirection : OptionSet{
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static var none: FXDirection {
        return FXDirection(rawValue: 0)
    }
    public static var top: FXDirection {
        return FXDirection(rawValue: 1)
    }
    public static var left: FXDirection {
        return FXDirection(rawValue: 2)
    }
    public static var bottom: FXDirection {
        return FXDirection(rawValue: 4)
    }
    public static var right: FXDirection {
        return FXDirection(rawValue: 8)
    }
}
///方向
public enum FXOrientation {
    ///横向
    case landscape
    ///竖向
    case portrait
}
extension FXOrientation {
    ///横向
    public var horizontal: FXOrientation { return .landscape}
    ///竖向
    public var vertical: FXOrientation { return .portrait}
}
