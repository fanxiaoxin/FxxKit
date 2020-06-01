//
//  Picker.swift
//  FXKit
//
//  Created by Fanxx on 2018/4/17.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

extension FX.NamespaceImplement where Base: UIView {
    @discardableResult
    public func pick(_ title:String?,contentView:UIView,completion:@escaping ()->Bool) -> FXPickerView{
        let pickerView = FXPickerView(title: title, contentView: contentView)
        pickerView.confirmAction = {
            if completion() {
                pickerView.hide()
            }
        }
        pickerView.show(self.base)
        return pickerView
    }
    public func pick(_ title:String?,date:Date?=nil,mode:UIDatePicker.Mode,min:Date?=nil,max:Date?=nil,completion: @escaping (Date?)->Bool){
        let pickerView = FXDatePickerView(title: title ?? "请选择日期", mode: mode)
        if let d  = date {
            pickerView.datePicker.date = d
        }
        if let m = min {
            pickerView.datePicker.minimumDate = m
        }
        if let mx = max {
            pickerView.datePicker.maximumDate = mx
        }
        pickerView.confirmAction = {
            if completion(pickerView.datePicker.date) {
                pickerView.hide()
            }
        }
        pickerView.show(self.base)
    }
    public func pick(_ title:String?,options:[[String]],selected:[Int]?,attributes:[NSAttributedString.Key:Any]? = nil,completion:@escaping ([Int])->Bool) {
        let pickerView = FXOptionsPickerView(title: title ?? "请选择", options:options,attributes:attributes)
        pickerView.confirmAction = {
            if completion(pickerView.selected) {
                pickerView.hide()
            }
        }
        pickerView.show(self.base)
        if let s = selected {
            pickerView.selected = s
        }
    }
}
