//
//  AttributedStringOperator.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/23.
//

import UIKit

extension String {
    @inlinable public static func + (lhs: String, rhs: NSAttributedString) -> NSMutableAttributedString {
        let str = rhs.mutableCopy() as! NSMutableAttributedString
        return lhs + str
    }
    @inlinable public static func + (lhs: NSAttributedString, rhs: String) -> NSMutableAttributedString {
        let str = lhs.mutableCopy() as! NSMutableAttributedString
        return str + rhs
    }
    @inlinable public static func + (lhs: String, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
        rhs.insert(NSAttributedString(string: lhs), at: 0)
        return rhs
    }
    @inlinable public static func + (lhs: NSMutableAttributedString, rhs: String) -> NSMutableAttributedString {
        lhs.append(NSAttributedString(string: rhs))
        return lhs
    }
}
extension NSAttributedString {
    @inlinable public static func + (lhs: NSAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
        rhs.insert(lhs, at: 0)
        return rhs
    }
    @inlinable public static func + (lhs: NSMutableAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        lhs.append(rhs)
        return lhs
    }
}
extension NSMutableAttributedString {
    @inlinable public static func + (lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
        lhs.append(rhs)
        return lhs
    }
}
