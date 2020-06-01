//
//  TextField.swift
//  FXKit
//
//  Created by Fanxx on 2019/7/24.
//

import UIKit

open class FXTextField: UITextField {
    ///内边距
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    public let placeHolderLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    open func load() {
        placeHolderLabel.text = text
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.textAlignment = self.textAlignment
        placeHolderLabel.sizeToFit()
        
        self.addSubview(placeHolderLabel)
        
        placeHolderLabel.font = self.font
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(FXTextField.textFieldDidChange), name: UITextField.textDidChangeNotification, object: self)
    }
    open override var font: UIFont? {
        didSet {
            self.placeHolderLabel.font = self.font
        }
    }
    open override var placeholder: String? {
        get {
            return self.placeHolderLabel.text
        }
        set {
            self.placeHolderLabel.text = newValue
        }
    }
    open override var attributedPlaceholder: NSAttributedString?{
        get {
            return self.placeHolderLabel.attributedText
        }
        set {
            self.placeHolderLabel.attributedText = newValue
        }
    }
    open override var textAlignment: NSTextAlignment {
        didSet {
            self.placeHolderLabel.textAlignment = self.textAlignment
        }
    }
    
    @objc func textFieldDidChange(hidePlaceHolder:Bool) {
        if (self.text?.count ?? 0) > 0 || hidePlaceHolder{
            placeHolderLabel.isHidden = true
        }else {
            placeHolderLabel.isHidden = false
        }
    }
    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += self.padding.left + self.padding.right
        size.height += self.padding.top + self.padding.bottom
        return size
    }
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.size.width -= self.padding.left * 2
        var rect = super.textRect(forBounds: b)
        rect.origin.x += self.padding.left
        rect.origin.y += self.padding.top
        return rect
    }
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var b = bounds
        b.size.width -= self.padding.left * 2
        var rect = super.editingRect(forBounds: b)
        rect.origin.x += self.padding.left
        rect.origin.y += self.padding.top
        return rect
    }
}
extension FXBuildable where Self: UIView {
    public static func fxText(_ styles: FXStyleSetting<FXTextField>...) -> FXTextField {
        return FXTextField().fx(styles: styles)
    }
}
extension FXStyleSetting where TargetType: FXTextField {
    public static func placeholder(style:FXStyleSetting<UILabel>...) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            style.forEach({ $0.action(target.placeHolderLabel) })
        })
    }
    public static func padding(_ padding:UIEdgeInsets) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.padding = padding
        })
    }
}
