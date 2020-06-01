//
//  FxDateTextConstraint.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/28.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

open class FXDateTextConstraint: FXTextConstraint {
    ///可对该Picker设置属性
    public var datePicker: UIDatePicker {
        return _datePicker
    }
    ///格式化字符串，默认：yyyy-MM-dd
    open var stringFormat: String = "yyyy-MM-dd" {
        didSet{
            self.updateText()
        }
    }
    ///值
    open var date: Date? {
        get{
            return self._date
        }
        set {
            self._date = newValue
            let d = self.date ?? {
                let today = Date()
                if let min = self._datePicker.minimumDate, min > today{
                    return min
                }
                return today
            }()
            _datePicker.date = d
            self.updateText()
        }
    }
    
    private let _datePicker = UIDatePicker()
    private var _date: Date? = nil
    
    override public init() {
        super.init()
        _datePicker.backgroundColor = UIColor.white
        _datePicker.datePickerMode = .date
        _datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    override public var textField: UITextField? {
        willSet{
            textField?.tintColor = UITextField.appearance().tintColor//显示光标
            textField?.inputView = nil
        }
        didSet { 
            textField?.inputView = _datePicker
            textField?.tintColor = UIColor.clear//将光标置为透明
            self.valueChanged()
        }
    }
    @objc func datePickerValueChanged() {
        _date = _datePicker.date
        self.valueChanged()
    }
    func updateText() {
        self.textField?.text = _date?.oc.string(withFormat: self.stringFormat)
    }
    func valueChanged() {
        self.updateText()
        self.textField?.sendActions(for: .editingChanged)
    }
    override open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension FX.NamespaceImplement where Base: UITextField {
    public  var date: Date? {
        get{
            if let tc = self.textConstraint as? FXDateTextConstraint {
                return tc.date
            }
            if let text = self.base.text {
                return NSDate(isoFormatString: text) as Date?
            }else{
                return nil
            }
        }
        set{
            if let tc = self.textConstraint as? FXDateTextConstraint {
                tc.date = newValue
            }else{
                self.base.text = newValue?.oc.stringWithISOFormat()
            }
        }
    }
}

extension FXTextConstraint {
    public static func date(mode:UIDatePicker.Mode = .date, format: String, min: Date? = nil, max: Date? = nil) -> FXTextConstraint {
        let tc = FXDateTextConstraint()
        tc.datePicker.datePickerMode = mode
        tc.stringFormat = format
        tc.datePicker.minimumDate = min
        tc.datePicker.maximumDate = max
        return tc
    }
}
