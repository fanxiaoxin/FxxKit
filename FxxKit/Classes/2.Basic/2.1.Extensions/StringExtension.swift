//
//  NSString+FXAdd.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import Foundation
import YYCategories

extension String {
    //转换为NSString对象
    public var oc : NSString {
        return  self as NSString
    }
}
///可转换为String
public protocol FXStringConvertible {
    init?(string: String)
    func toString() -> String
}
extension FX.NamespaceImplement where Base == String {
    ///判断该字符串是否为空，包括空字符串
    public var isBlank: Bool {
        let blank = CharacterSet.whitespacesAndNewlines
        return self.base.trimmingCharacters(in: blank).isEmpty
    }
    ///判断该字符串是否为空，包括空字符串，若为空则返回nil,否则返回源字符串
    public var notEmpty: String? {
        if self.isBlank {
            return nil
        }else{
            return self.base
        }
    }
    //取前几个字符
    public func first(_ count: Int = 1) -> String {
        if count > 0 {
            if  self.base.count > count {
                let startIndex = self.base.startIndex
                let endIndex =  self.base.index(startIndex, offsetBy: count)
                let subString =  self.base[startIndex..<endIndex]
                return String(subString)
            } else {
                return  self.base
            }
        }else{
            if self.base.count > -count {
                let startIndex = self.base.startIndex
                let endIndex =  self.base.index(self.base.endIndex, offsetBy: count)
                let subString =  self.base[startIndex..<endIndex]
                return String(subString)
            } else {
                return  self.base
            }
        }
    }
    //取后几个字符
    public func last(_ count: Int = 1) -> String {
        if count > 0 {
            if  self.base.count > count {
                let endIndex =  self.base.endIndex
                let startIndex = self.base.index(endIndex, offsetBy: -count)
                let subString =  self.base[startIndex..<endIndex]
                return String(subString)
            } else {
                return  self.base
            }
        }else{
            let c = -count
            if  self.base.count > c {
                let endIndex =  self.base.endIndex
                let startIndex = self.base.index(self.base.startIndex, offsetBy: c)
                let subString =  self.base[startIndex..<endIndex]
                return String(subString)
            } else {
                return  self.base
            }
        }
    }
    //取中间几个字符
    public func middle(_ index:Int, _ count: Int = 1) -> String {
        if  self.base.count > index {
            let startIndex =  self.base.index(self.base.startIndex, offsetBy: index)
            let endIndex:String.Index
            if self.base.count > index + count {
                endIndex =  self.base.index(startIndex, offsetBy: count)
            }else{
                endIndex =  self.base.endIndex
            }
            let subString =  self.base[startIndex..<endIndex]
            
            return String(subString)
        } else {
            return  self.base
        }
    }
    //获取指定字体的大小
    public func size(for font:UIFont) -> CGSize {
        return  self.base.oc.size(for: font, size: CGSize.zero, mode: .byTruncatingTail)
    }
    ///根据字体和指定大小转换文字，超出的文字用省略号显示
    public func reduce(for font:UIFont,width:CGFloat) -> String {
        let charWidth = " ".fx.size(for: font).width
        let bigCharWidth = "国".fx.size(for: font).width
        let totalWidth =  self.size(for: font).width
        if (totalWidth <= width) {
            return  self.base
        }
        let ellipsesWidth = "...".fx.size(for: font).width
        let saveWidth = width - ellipsesWidth
        var saveCount = Int(saveWidth / charWidth)
        var saveString =  self.first(saveCount)
        var currentWidth = saveString.fx.size(for: font).width
        
        while (currentWidth > saveWidth) {
            saveCount = saveCount - Int((currentWidth - saveWidth) / bigCharWidth)
            saveString =  self.first(saveCount)
            currentWidth = saveString.fx.size(for: font).width
        }
        
        return saveString.appending("...")
    }
    public var urlEncode: String {
        return self.base.oc.byURLEncode()
    }
    public var urlDecode: String {
        return self.base.oc.byURLDecode()
    }
    public func appendingURL(path: String? = nil, parameters:[String: CustomStringConvertible]?) -> String {
        var result = self.base
        if let p = path {
            result = p.oc.appendingPathComponent(p)
        }
        if let p = parameters {
            var parameter = ""
            p.forEach { kv in
                parameter = parameter.appending("&\(kv.key.fx.urlEncode)=\(kv.value.description.fx.urlEncode))")
            }
            if let idx = result.firstIndex(of: "?") {
                parameter = parameter.replacingCharacters(in: Range<String.Index>(uncheckedBounds: (lower: idx, upper: idx)), with: "?")
            }
            result = result.appending(parameter)
        }
        return result
    }
    ///将html字符串转码成普通字符串
    public var html: String? {
        if let data = self.base.data(using: .unicode) {
            if let c = try? NSAttributedString(data: data, options: [.documentType :NSAttributedString.DocumentType.html], documentAttributes: nil) {
                return c.string
            }
        }
        return self.base
    }
    ///字符长度，中文2个字符，英文1个字符
    public var lengthOfBytes: UInt {
        var asciiLength: UInt = 0
        for uc in self.base {
            asciiLength += uc.isASCII ? 1: 2
        }
        return asciiLength;
    }
}

//##### 格式验证 #####
extension FX.NamespaceImplement where Base == String {
    //验证是否符合正则表达式
    public func validate(reg:String) -> Bool {
        return  self.base.oc.range(of: reg, options: .regularExpression).location != NSNotFound
    }
    //验证是否手机号
    public func validatePhone() -> Bool {
        //        return self.validate(reg: "^1[3|5|7|8][0-9]\\d{8}$")
        return self.validate(reg: "^1\\d{10}$")
    }
}

//##### 版本判断 #####
extension FX.NamespaceImplement where Base == String {
    //是否比另一个版本号大
    public func isVersionLater(than ver:String?) -> Bool {
        if (ver == nil) {
            return true
        }
        let v1 =  self.base, v2 = ver!
        let separateSet = CharacterSet(charactersIn: ".")
        let v1s = v1.components(separatedBy: separateSet)
        let v2s = v2.components(separatedBy: separateSet)
        for i in 0..<v1s.count {
            let sv1 = Int(v1s[i]) ?? 0
            let sv2 = i < v2s.count ? (Int(v2s[i]) ?? 0) : 0
            if sv1 == sv2 {
                continue
            }else{
                return sv1 > sv2
            }
        }
        return false;
    }
}

extension FX.NamespaceImplement where Base: NSAttributedString {
    ///获取在某个点上的文字索引，可用于点击事件根据对应的文字做不同的操作
    public func characterIndex(at point: CGPoint, for size: CGSize, numberOfLines: Int = 0) -> Int? {
        let text = self.base
        
        let attributedText = text.mutableCopy() as! NSMutableAttributedString
        
        let lineSpace: CGFloat
        if let style = attributedText.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
            lineSpace = style.lineSpacing
            //Truncating获取到的lines永远只有一行，所以需要改掉
            if style.lineBreakMode.in(.byTruncatingHead, .byTruncatingTail, .byTruncatingMiddle) {
                attributedText.removeAttribute(.paragraphStyle, range: NSMakeRange(0, attributedText.length))
                let ps = style.mutableCopy() as! NSMutableParagraphStyle
                ps.lineBreakMode = .byCharWrapping
                attributedText.addAttributes([.paragraphStyle: ps], range: NSMakeRange(0, attributedText.length))
            }
        }else{
            lineSpace = 0
        }
        
        let bounds = CGRect(origin: .zero, size: size)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        
        let path = CGMutablePath()
        path.addRect(bounds)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        let lines = CTFrameGetLines(frame) as! [CTLine]
        let count = lines.count//CFArrayGetCount(lines)
        let lineCount = numberOfLines > 0 ? min(numberOfLines, count) : count
        
        if lineCount == 0 {
            return nil
        }
        
        var origins: [CGPoint] = Array<CGPoint>(repeating: .zero, count: count)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, lineCount), &origins)
        
        let transform = CGAffineTransform(translationX: 0, y: bounds.size.height).scaledBy(x: 1, y: -1)
        //            let verticalOffset: CGFloat = 0
        let ctp = point
        
        for i in 0..<lineCount {
            let line = lines[i]
            
            var ascent:CGFloat = 0
            var descent:CGFloat = 0
            var leading:CGFloat = 0
            let width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, &leading))
            let height = ascent + abs(descent*2) + leading
            
            //                let flippedRect = CGRect(x: point.x, y: point.y, width: width, height: height)
            //                var rect = flippedRect.applying(transform)
            //
            //                rect = rect.insetBy(dx: 0, dy: 0)
            //                rect = rect.offsetBy(dx: 0, dy: verticalOffset)
            var rect = CGRect(x: origins[i].x, y: origins[i].y, width: width, height: height)
            rect = rect.applying(transform)
            
            //                let l1 = lineSpace * CGFloat(count - 1)
            //                let lineOutSpace = (bounds.size.height - l1 - rect.size.height * CGFloat(count)) / 2
            let l1 = lineSpace * CGFloat(lineCount - 1)
            let lineOutSpace = (bounds.size.height - l1 - rect.size.height * CGFloat(lineCount)) / 2
            rect.origin.y = lineOutSpace + rect.size.height * CGFloat(i) + lineSpace * CGFloat(i)
            
            if rect.contains(ctp) {
                let relativePoint = CGPoint(x: ctp.x, y: ctp.y)
                var index = CTLineGetStringIndexForPosition(line, relativePoint)
                var offset: CGFloat = 0
                CTLineGetOffsetForStringIndex(line, index, &offset)
                
                if (offset > relativePoint.x) {
                    index = index - 1
                }
                if index >= 0 {
                    return index
                }else{
                    return nil
                }
            }
        }
        
        return nil
    }
}

extension FX.NamespaceImplement where Base == String {
    ///将所有的字符串连起来，若其中有一个为nil则返回nil
    public static func notEmpty(_ parts: Any?...) -> String? {
        let result = NSMutableString()
        for part in parts {
            if let p = part {
                result.append("\(p)")
            }else {
                return nil
            }
        }
        return result as String
    }
}
extension FX.NamespaceImplement where Base == Int {
    public func chinese() -> String {
        let numbers = ["零","一","二","三","四","五","六","七","八","九","十"]
        if self.base <= 10 {
            return numbers[self.base]
        } else if self.base < 20 {
            return "十" + numbers[self.base - 10]
        } else if self.base < 100 {
            return (numbers[self.base / 10] + "十" + numbers[self.base % 10]).trimmingCharacters(in: .init(charactersIn: "零"))
        } else {
            return self.base.description
        }
    }
}
extension FX {
    typealias StringConvertible = FXStringConvertible
}
