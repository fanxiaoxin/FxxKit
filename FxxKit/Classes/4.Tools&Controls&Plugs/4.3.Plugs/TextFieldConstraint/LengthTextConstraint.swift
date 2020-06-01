
//
//  LengthTextConstraint.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/8.
//

import UIKit
///长度限制
open class FXLengthTextConstraint: FXTextConstraint {
    var keyboardType: UIKeyboardType? = nil
    public override var textField: UITextField?{
        didSet {
            if let kb = self.keyboardType {
                self.textField?.keyboardType = kb
            }
        }
    }
    ///小数点后的位数，设为0则没有小数点，仅用于浮点数
    public var maxLength = 0
    ///是否按字节计数，区分中英文，为true则中文算2个长度
    public var isCountByByte = false
    public init(_ max: Int) {
        super.init()
        self.maxLength = max
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
        if self.isCountByByte {
            if result.fx.lengthOfBytes > maxLength {
                return false
            }
        }else{
            if result.count > maxLength {
                return false
            }
        }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}

extension FXTextConstraint {
    public static var phone: FXTextConstraint {
        let c = FXLengthTextConstraint(11)
        c.keyboardType = .phonePad
        return c
    }
    public static func max(length:Int,isCountByByte:Bool = false) -> FXTextConstraint {
        let c = FXLengthTextConstraint(length)
        c.isCountByByte = isCountByByte
        return c
    }
}
