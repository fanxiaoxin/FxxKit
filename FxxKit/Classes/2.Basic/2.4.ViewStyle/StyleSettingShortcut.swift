//
//  ViewBuilderShortcut.swift
//  FXKit
//
//  Created by Fanxx on 2019/12/20.
//

import UIKit

extension FXBuildable where Self: UIView {
    public static func view(_ styles: FXStyleSetting<UIView>...) -> UIView {
        return UIView().fx(styles: styles)
    }
    public static func label(_ styles: FXStyleSetting<UILabel>...) -> UILabel {
        return UILabel().fx(styles: styles)
    }
    public static func button(_ styles: FXStyleSetting<UIButton>...) -> UIButton {
        return UIButton().fx(styles: styles)
    }
    public static func image(_ named: String?, _ styles: FXStyleSetting<UIImageView>...) -> UIImageView {
        let img = UIImageView().fx(styles: styles)
        if let n = named {
            img.image = UIImage(named: n)
        }
        return img
    }
    public static func text(_ styles: FXStyleSetting<UITextField>...) -> UITextField {
        return UITextField().fx(styles: styles)
    }
    public static func textView(_ styles: FXStyleSetting<UITextView>...) -> UITextView {
        return UITextView().fx(styles: styles)
    }
    public static func page(_ styles: FXStyleSetting<UIPageControl>...) -> UIPageControl {
        return UIPageControl().fx(styles: styles)
    }
}
///更细微的扩展
extension FX.NamespaceImplement where Base: UIView {
    ///添加ScrollView，返回ScrollView的内容页
    @discardableResult
    public func scroll(_ scrollView: UIScrollView? = nil, contentView: UIView? = nil, orientation:FXOrientation = .portrait, layout:[FXViewLayout] = [], style: FXStyleSetting<UIScrollView>...) -> NamespaceWrapper<UIView> {
        let scroll = scrollView ?? UIScrollView()
        style.forEach({$0.action(scroll)})
        let content = contentView ?? UIView()
        let os: FXViewLayout
        switch orientation {
        case .landscape: os = .height
        case .portrait: os = .width
        }
        return self.add(scroll, layout: .margin)
            .add(content, layout: layout, ext: .margin, os)
    }
}
