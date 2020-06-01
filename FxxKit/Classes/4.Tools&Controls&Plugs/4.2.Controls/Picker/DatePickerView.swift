//
//  FXDatePickerView.swift
//  FXKit
//
//  Created by Fanxx on 2018/4/17.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

open class FXDatePickerView: FXPickerView {
    public let datePicker = UIDatePicker()
    
    public init(title:String,mode:UIDatePicker.Mode){
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = mode
        datePicker.frame = CGRect(x: 0,y: 0,width: 10,height: 162)
        datePicker.backgroundColor = UIColor.clear
        super.init(title: title, contentView: self.datePicker)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
