//
//  TextView.swift
//  FXKit
//
//  Created by Fanxx on 2019/8/12.
//

import UIKit

public class FXTextView: UITextView {
    ///水印
    public var placeholder: String? {
        get {
          return self.placeholderLabel.text
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    ///水印控件
    public let placeholderLabel = UILabel()
    public override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = self.font
        }
    }
    public override var text: String! {
        didSet {
            self.textChanged()
        }
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.load()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    open func load() {
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.font = self.font
        self.placeholderLabel.backgroundColor = .clear
        self.placeholderLabel.alpha = 1
        self.placeholderLabel.textColor = .lightGray
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(4)
            make.width.equalTo(self).offset(-8)
            make.top.equalTo(self).offset(8)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name:UITextView.textDidChangeNotification, object: self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    @objc func textChanged() {
        self.placeholderLabel.alpha = (self.text.count == 0) ? 1 : 0
    }
}

extension FXBuildable where Self: UIView {
    public static func fxTextView(_ styles: FXStyleSetting<FXTextView>...) -> FXTextView {
        return FXTextView().fx(styles: styles)
    }
}

extension FXStyleSetting where TargetType: FXTextView {
    ///占位文本
    public static func placeholder(_ text:String?, color: UIColor? = nil, font: UIFont? = nil) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.placeholder = text
            if let c = color {
                target.placeholderLabel.textColor = c
            }
            if let f = font {
                target.placeholderLabel.font = f
            }
        })
    }
}
