//
//  NumberTextConstraint.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

///文本限制，一次只能用在一个TextField，多个TextField一样的规则请使用多个，不然所有TextField的Delegate都会变成同一个
open class FXNumberTextConstraint<T:Numeric>: FXTextConstraint, FXEventTriggerable where T:LosslessStringConvertible,T:Comparable {
    public typealias EventType = Event
    public enum Event: FXEventType {
        ///超过最大值
        case outOfMax
    }
    ///小数点后的位数，设为0则没有小数点，仅用于浮点数
    public var decimalLength = 0 {
        didSet {
            self.formatter.maximumFractionDigits = decimalLength
        }
    }
    ///是否允许负数
    public var allowNegative = false
    ///最小值
    public var min: T? = nil {
        didSet {
            self.value = self.finalValue(for: self.value)
        }
    }
    ///最大值
    public var max: T? = nil {
        didSet {
            self.value = self.finalValue(for: self.value)
        }
    }
    ///值
    public var value: T? {
        get{
            self.updateRawValue()
            return _rawValue
        }
        set{
            _rawValue = self.finalValue(for: newValue)
            if _isFXEditing {
                self.textField?.text = self.editingTextFormat(_rawValue)
            }else{
                self.textField?.text = self.textFormat(_rawValue)
            }
        }
    }
    ///显示格式化
    public var formatter: NumberFormatter = NumberFormatter()
    
    ///编辑前的值
    private var _rawValue: T?
    ///编辑后的值，好像用不到了，忘了一开始为何加进来
    private var _editingValue: T?
    ///用于判断是否正在编辑
    private var _isFXEditing: Bool = false
    
    //*********************格式化
    ///一般状态的文字显示
    open func textFormat(_ value:T?) -> String{
        if let v = value,let tf = self.textField {
            if !tf.isFirstResponder,let str = self.formatter.string(for: v) {
                return str
            }else{
                if (self.decimalLength > 0) {
                    if let f = v as? CVarArg {
                        return String(format: "%.\(self.decimalLength)f", f)
                    }else{
                        return v.description
                    }
                }else{
                    return v.description
                }
            }
        }else{
            return ""
        }
    }
    ///编辑中的文字显示
    open func editingTextFormat(_ value:T?) -> String{
        if let v = value {
            var str = v.description
            if (self.decimalLength > 0) {
                if let f = v as? CVarArg {
                    str = String(format: "%.\(self.decimalLength)f", f)
                }else{
                    str = v.description
                }
            }
            if str.contains(".") {
                str = str.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
                if str.hasSuffix(".") {
                    str.removeLast(1)
                }
            }
            if str.isEmpty {
                return "0"
            }else{
                return str
            }
        }else{
            return ""
        }
    }
    
    public override init() {
        super.init()
        formatter.numberStyle = .decimal
        if T("0")?.description.contains(".") ?? false {//判断是否浮点数，暂时没有更好的办法
            self.decimalLength = 2
        }
    }
    public override var textField: UITextField?{
        didSet{
            if let tf = self.textField {
                if let text = tf.text {
                    _rawValue = T(text)
                }else{
                    _rawValue = nil
                }
                _isFXEditing = textField?.isFirstResponder ?? false
                _editingValue = nil
                if T("0")?.description.contains(".") ?? false {
                    textField?.keyboardType = .decimalPad
                }else{
                    textField?.keyboardType = .numberPad
                }
            }
        }
    }
    //***** 判断逻辑 *****
    func setEditing(value:T?) {
//        _editingValue = value
        self.textField?.text = self.editingTextFormat(value)
        self.textField?.sendActions(for: .editingChanged)
    }
    func updateRawValue() {
        if _isFXEditing {
            if let v = _editingValue {
                _rawValue = v
                _editingValue = nil
            }else if let text = self.textField?.text, !text.fx.isBlank {
                _rawValue = T(text)
            }else{
                _rawValue = nil
            }
            _rawValue = self.finalValue(for: _rawValue)
        }
    }
    open func finalValue(for value:T?) -> T? {
        //最小值在编辑时不强制更改，但是结束编辑时强制
        if let min = self.min,let v = value, min > v {
            return min
        }
        if let max = self.max,let v = value, max < v {
            return max
        }
        return value
    }
    open override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ///如果是退格则一直允许
        if (string.fx.isBlank) {
            return true
        }
        let result:String
        if let text = textField.text,let rg = Range(range, in: text) {
            result = text.replacingCharacters(in: rg, with: string)
        }else{
            result = string
        }
        if result.fx.isBlank {
            return true
        }
        //判断负数
        if self.allowNegative && result == "-" {
            return true
        }
        //整数不能加小数点
        if self.decimalLength <= 0 && result.contains(".") {
            return false
        }
        //最前面不要一堆0
        if result.range(of: "^-+0[^\\.]+", options: .regularExpression, range: nil, locale: nil) != nil {
            return false
        }
        //小数点位数不能超
        let ds = result.split(separator: Character("."))
        if ds.count > 1 && ds.last!.count > self.decimalLength {
            return false
        }
        ///看能否转化为数字
        if let value = T(result) {
            if !self.allowNegative && value < 0 {
                return false
            }
            if let max = self.max, max < value {
                self.setEditing(value: max)
                self.send(event: .outOfMax, result: value)
                return false
            }
            /* 最小值在编辑时不强制更改，但是结束编辑时强制
            if let min = self.min, min > value {
                self.setEditing(value: min)
                return false
            }
            */
        }else{
            return false
        }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    open override func textFieldDidEndEditing(_ textField: UITextField) {
        self.didEndEditing(for: textField)
        super.textFieldDidEndEditing(textField)
    }
    @available(iOS 10.0, *)
    open override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.didEndEditing(for: textField)
        super.textFieldDidEndEditing(textField, reason: reason)
    }
    func didEndEditing(for textField:UITextField) {
        self.updateRawValue()
        _isFXEditing = false
        if let v = _rawValue {
            textField.text = self.textFormat(v)
            textField.sendActions(for: .editingChanged)
        }
    }
    open override func textFieldDidBeginEditing(_ textField: UITextField) {
        _isFXEditing = true
        textField.text = self.editingTextFormat(_rawValue);
        _editingValue = nil
    }
}

extension FX.NamespaceImplement where Base: UITextField {
    public func number<T:Numeric>() -> T? where T: LosslessStringConvertible,T:Comparable{
        if let tc = self.textConstraint as? FXNumberTextConstraint<T> {
            return tc.value
        }
        if let text = self.base.text {
            return T(text)
        }else{
            return nil
        }
    }
    public func number<T:Numeric>(_ value: T?) where T: LosslessStringConvertible,T:Comparable{
        if let tc = self.textConstraint as? FXNumberTextConstraint<T> {
            tc.value = value
        }else{
            self.base.text = value?.description
        }
    }
}

extension FXTextConstraint {
    public static var money: FXTextConstraint {
        return .double(format: "###,##0.00", decimalLength: 2, min: nil, max: nil)
    }
    public static func money(decimalLength:Int = 2, min:Double? = nil, max: Double? = nil) -> FXTextConstraint {
        let format = NSMutableString(string:"###,##0")
        if (decimalLength > 0) {
            format.append(".")
            for _ in 0...decimalLength - 1 {
                format.append("0")
            }
        }
        return .double(format: format as String, decimalLength: 2, min: nil, max: nil)
    }
    public static func double(format:String? = nil, decimalLength:Int = 0, min:Double? = nil, max: Double? = nil) -> FXTextConstraint {
        let c = FXNumberTextConstraint<Double>()
        c.formatter.positiveFormat = format
        c.decimalLength = decimalLength
        c.min = min
        c.max = max
        return c
    }
    public static func int(format:String? = nil, min:Int? = nil, max: Int? = nil) -> FXTextConstraint {
        let c = FXNumberTextConstraint<Int>()
        c.formatter.positiveFormat = format
        c.decimalLength = 0
        c.min = min
        c.max = max
        return c
    }
}
