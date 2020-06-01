//
//  FXOptionsPickerView.swift
//  FXKit
//
//  Created by Fanxx on 2018/4/17.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

///通用的选择器
open class FXOptionsPickerView: FXPickerView,UIPickerViewDataSource,UIPickerViewDelegate {
    public let picker = UIPickerView()
    public var options :[[String]]
    public var attributes:[NSAttributedString.Key:Any]?
    public var selected:[Int] {
        get{
            var r:[Int] = []
            for i in 0...self.options.count - 1 {
                r.append(self.picker.selectedRow(inComponent: i))
            }
            return r
        }
        set{
            for i in 0...newValue.count - 1 {
                self.picker.selectRow(newValue[i], inComponent: i, animated: false)
            }
        }
    }
    public init(title:String,options:[[String]],attributes:[NSAttributedString.Key:Any]? = nil){
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.frame = CGRect(x: 0,y: 0,width: 10,height: 162)
        picker.backgroundColor = UIColor.clear
        self.options = options
        self.attributes = attributes
        super.init(title: title, contentView: self.picker)
        picker.dataSource = self
        picker.delegate = self
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.options.count
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.options[component].count
    }
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.options[component][row], attributes: self.attributes)
    }
}
