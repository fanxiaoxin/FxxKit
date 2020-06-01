//
//  AttributedStringBuilder.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/23.
//

import UIKit

public protocol FXAttributedStringPartType {
    
}
extension String: FXAttributedStringPartType {
    
}
public class FXAttributedStringPart: FXAttributedStringPartType {
    var string: String
    var attrs: [FXStringAttribute]
    public init(string: String, attrs: [FXStringAttribute]) {
        self.string = string
        self.attrs = attrs
    }
    public static func part(_ part: FXAttributedStringPartType, _ attrs: FXStringAttribute...) -> FXAttributedStringPart {
        if let str = part as? String {
            return FXAttributedStringPart(string: str, attrs: attrs)
        } else if let p = part as? FXAttributedStringPart {
            p.attrs.append(contentsOf: attrs)
            return p
        } else {
            return FXAttributedStringPart(string: "", attrs: attrs)
        }
    }
    public static func & (lhs: String, rhs: FXAttributedStringPart) -> FXAttributedStringPart {
        for i in 0..<rhs.attrs.count {
            if let range = rhs.attrs[i].range {
                rhs.attrs[i].range = NSMakeRange(lhs.count + range.location , range.length <= 0 ? rhs.string.count : range.length)
            } else {
                rhs.attrs[i].range = NSMakeRange(lhs.count, rhs.string.count)
            }
        }
        rhs.string = lhs + rhs.string
        return rhs
    }
    public static func & (lhs: FXAttributedStringPart, rhs: String) -> FXAttributedStringPart {
        for i in 0..<lhs.attrs.count {
            if let range = lhs.attrs[i].range {
                if range.length <= 0 {
                    lhs.attrs[i].range = NSMakeRange(range.location, lhs.string.count)
                }
            } else {
                lhs.attrs[i].range = NSMakeRange(0, lhs.string.count)
            }
        }
        lhs.string += rhs
        return lhs
    }
    public static func & (lhs: FXAttributedStringPart, rhs: FXAttributedStringPart) -> FXAttributedStringPart {
        for i in 0..<lhs.attrs.count {
            if let range = lhs.attrs[i].range {
                if range.length <= 0 {
                    lhs.attrs[i].range = NSMakeRange(range.location, lhs.string.count)
                }
            } else {
                lhs.attrs[i].range = NSMakeRange(0, lhs.string.count)
            }
        }
        for i in 0..<rhs.attrs.count {
            if let range = rhs.attrs[i].range {
                rhs.attrs[i].range = NSMakeRange(lhs.string.count + range.location , range.length <= 0 ? rhs.string.count : range.length)
            } else {
                rhs.attrs[i].range = NSMakeRange(lhs.string.count, rhs.string.count)
            }
        }
        lhs.string += rhs.string
        lhs.attrs.append(contentsOf: rhs.attrs)
        return lhs
    }
}

extension NSAttributedString {
    public static func fx(_ part: FXAttributedStringPartType, _ attrs: FXStringAttribute...) -> NSMutableAttributedString {
        if let str = part as? String {
            let result = NSMutableAttributedString(string: str)
            attrs.forEach({ $0.apply(result) })
            return result
        } else if let p = part as? FXAttributedStringPart {
            let result = NSMutableAttributedString(string: p.string)
            attrs.forEach({ $0.apply(result) })
            p.attrs.forEach({ $0.apply(result) })
            return result
        } else {
            let result = NSMutableAttributedString(string: "")
            attrs.forEach({ $0.apply(result) })
            return result
        }
    }
}
