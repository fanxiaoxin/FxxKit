//
//  OptionsTextConstraint.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/28.
//

import UIKit

open class FXOptionsTextConstraint<OptionsKeyboardType: FXOptionsKeyboardType>: FXTextConstraint {
    
    public let keyboard: OptionsKeyboardType
    ///观察者，用于观察OptionsView的改变
//    private var optionsObservation: NSKeyValueObservation?
    public init(_ keyboard: OptionsKeyboardType) {
        self.keyboard = keyboard
        super.init()
//        optionsView.finish = { [weak self] value in
//            self?.value = value
//            self?.textField?.resignFirstResponder()
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.optionsValueChanged(notification:)), name: OptionsKeyboardType.selectedValueChangedKey, object: keyboard)
    }
    @objc func optionsValueChanged(notification:NSNotification) {
        if let obj = notification.object as? OptionsKeyboardType{
            if obj == self.keyboard {
                self.valueChanged()
                self.textField?.resignFirstResponder()
            }
        }
    }
    
    override open var textField: UITextField? {
        willSet{
            textField?.tintColor = UITextField.appearance().tintColor//显示光标
            textField?.inputView = nil
        }
        didSet {
            textField?.inputView = self.keyboard
            textField?.tintColor = UIColor.clear//将光标置为透明
            self.valueChanged()
        }
    }
    ///值
    open var value: OptionsKeyboardType.ValueType? {
        get {
            return self.keyboard.selectedValue
        }
        set {
            self.keyboard.selectedValue = newValue
        }
    }
    func updateText() {
        self.textField?.text = self.keyboard.selectedValue?.optionValueTitle
    }
    func valueChanged() {
        self.updateText()
        self.textField?.sendActions(for: .valueChanged)
    }
    override open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    open override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        self.keyboard.load(value: self.value)
    }
}

extension FXTextConstraint {
    public static func options<KeyboardType: FXOptionsKeyboardType>(_ keyboard: KeyboardType) -> FXTextConstraint {
        let c = FXOptionsTextConstraint<KeyboardType>(keyboard)
        return c
    }
}
