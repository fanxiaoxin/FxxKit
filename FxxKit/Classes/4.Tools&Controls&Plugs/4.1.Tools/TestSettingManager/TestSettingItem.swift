//
//  TestSettingItem.swift
//  FXKit
//
//  Created by Fanxx on 2019/7/31.
//

import UIKit

open class FXTestSettingItem {
    open class Value {
        open var name: String
        open var value: Any?
        public init(_ name: String,_ value: Any?) {
            self.name = name
            self.value = value
        }
    }
    open var name: String
    open var value: Any?
    open var options: [Value]?
    public init(name: String, value: Any?, options: Value...) {
        self.name = name
        self.value = value
        self.options = options
    }
}
