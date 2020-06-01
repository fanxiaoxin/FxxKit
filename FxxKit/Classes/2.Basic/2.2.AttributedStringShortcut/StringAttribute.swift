//
//  StringAttribute.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/22.
//

import UIKit

public struct FXStringAttribute {
    public var attributes: [NSAttributedString.Key: Any]
    ///为nil则表示全局
    public var range: NSRange?
    
    public init(_ key: NSAttributedString.Key, _ value: Any, range: NSRange? = nil) {
        self.attributes = [key: value]
        self.range = range
    }
    public init(_ attrs: [NSAttributedString.Key: Any], range: NSRange? = nil) {
        self.attributes = attrs
        self.range = range
    }
    ///指定作用范围, len<=0则代表到结尾
    public static func range(_ loc: Int,_ len: Int,_ attrs: FXStringAttribute...) -> FXStringAttribute {
        var values: [NSAttributedString.Key: Any] = [:]
        for a in attrs {
            values.merge(a.attributes) { (v, _) -> Any in return v }
        }
        return .init(values, range: NSMakeRange(loc, len))
    }
    ///指定作用范围, len<=0则代表到结尾
    public static func range(_ range: NSRange,_ attrs: FXStringAttribute...) -> FXStringAttribute {
        var values: [NSAttributedString.Key: Any] = [:]
        for a in attrs {
            values.merge(a.attributes) { (v, _) -> Any in return v }
        }
        return .init(values, range: range)
    }
    ///应用
    public func apply(_ string: NSMutableAttributedString) {
        var range: NSRange
        if let r = self.range {
            if r.length <= 0 {
                range = NSMakeRange(r.location, string.length - r.location)
            }else{
                range = r
            }
        }else{
            range = NSMakeRange(0, string.length)
        }
        string.addAttributes(self.attributes, range: range)
    }
}
extension FX.NamespaceImplement where Base == String {
    public func attr(_ attrs: FXStringAttribute...) -> NSAttributedString {
        if attrs.count == 0 {
            return NSAttributedString(string: self.base)
        } else if attrs.count == 1 {
            if attrs[0].range == nil {
                return NSAttributedString(string: self.base, attributes: attrs[0].attributes)
            }
        }
        let str = NSMutableAttributedString(string: self.base)
        attrs.forEach({ $0.apply(str) })
        return str
    }
    public func mutableAttr(_ attrs: FXStringAttribute...) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(string: self.base)
        attrs.forEach({ $0.apply(str) })
        return str
    }
}
extension FX.NamespaceImplement where Base: NSAttributedString {
    public func attr(_ attrs: FXStringAttribute...) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(attributedString: self.base)
        attrs.forEach({ $0.apply(str) })
        return str
    }
}
extension FX.NamespaceImplement where Base: NSMutableAttributedString {
    @discardableResult
    public func attr(_ attrs: FXStringAttribute...) -> Base {
        attrs.forEach({ $0.apply(self.base) })
        return self.base
    }
    @discardableResult
    public func reg(_ reg: String, options:  NSRegularExpression.Options = .caseInsensitive, _ attrs: FXStringAttribute...) -> Base {
        var values: [NSAttributedString.Key: Any] = [:]
        for a in attrs {
            values.merge(a.attributes) { (v, _) -> Any in return v }
        }
        
        let reg = try? NSRegularExpression(pattern: reg, options: options)
        reg?.enumerateMatches(in: self.base.string, options: .reportProgress, range: NSRange(location: 0, length: self.base.string.count)) { (result, flags, _) in
            if let r = result {
                FXStringAttribute(values, range: r.range).apply(self.base)
            }
        }
        return self.base
    }
}
