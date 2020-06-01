
//
//  UILabelExtension.swift
//  FXKit
//
//  Created by Fanxx on 2019/8/15.
//

import UIKit

extension FX.NamespaceImplement where Base: UILabel {
    ///获取在某个点上的文字索引，可用于点击事件根据对应的文字做不同的操作
    public func characterIndex(at point: CGPoint) -> Int? {
        if let text = self.base.attributedText {

            let at = text.fx.attr(.paragraph(.lineBreak(self.base.lineBreakMode)))
            if let f = self.base.font { at.fx.attr(.font(f)) }
            
            return at.fx.characterIndex(at: point, for: self.base.bounds.size, numberOfLines: self.base.numberOfLines)
            /*
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
             
             let bounds = self.base.bounds
             
             let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
             
             let path = CGMutablePath()
             path.addRect(bounds)
             let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
             
             let lines = CTFrameGetLines(frame) as! [CTLine]
             let count = lines.count//CFArrayGetCount(lines)
             let numberOfLines = self.base.numberOfLines > 0 ? min(self.base.numberOfLines, count) : count
             
             if numberOfLines == 0 {
             return nil
             }
             
             var origins: [CGPoint] = Array<CGPoint>(repeating: .zero, count: count)
             CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), &origins)
             
             let transform = CGAffineTransform(translationX: 0, y: bounds.size.height).scaledBy(x: 1, y: -1)
             //            let verticalOffset: CGFloat = 0
             let ctp = point
             
             for i in 0..<numberOfLines {
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
             let l1 = lineSpace * CGFloat(numberOfLines - 1)
             let lineOutSpace = (bounds.size.height - l1 - rect.size.height * CGFloat(numberOfLines)) / 2
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
             */
        }
        return nil
    }
}
