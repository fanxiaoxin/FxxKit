//
//  OptionsKeyboardType.swift
//  FXKit
//
//  Created by Fanxx on 2019/8/28.
//

import UIKit

///选项值类型
public protocol FXOptionValueType: Equatable {
    ///选项名
    var optionValueTitle: String? { get }
}
extension FXOptionValueType where Self: CustomStringConvertible{
    ///选项名
    public var optionValueTitle: String? {
        return self.description
    }
}
extension String: FXOptionValueType { }
///带栏高260, 不带栏高216
public protocol FXOptionsKeyboardType: UIView {
    associatedtype ValueType: FXOptionValueType
    func load(value: ValueType?)
}
extension FXOptionsKeyboardType {
    ///选中值
    public var selectedValue: ValueType? {
        get {
            return self.fx.getAssociated(object: "SelectedValue")
        }
        set {
            self.fx.setAssociated(object: newValue, key: "SelectedValue")
            self.load(value: newValue)
            NotificationCenter.default.post(name: Self.selectedValueChangedKey , object: self)
        }
    }
    public static var selectedValueChangedKey: NSNotification.Name {
        return NSNotification.Name("FXOptionsViewSelectedValueChangedKey")
    }
}
