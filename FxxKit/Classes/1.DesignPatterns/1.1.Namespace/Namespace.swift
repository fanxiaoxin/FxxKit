//
//  FXNamespace.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/3.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
/**************
 规则说明（以Cls举例代表具体类名）：
 
 类名统一为：FXCls并且另名为FX.Cls
 即：
 class FXCls {}
 extension FX {
    typealias Cls = FXCls
 }
 
 系统或外部类扩展统一为：Cls.fx.***
 即：
 extension Cls: FX.NamespaceDefine {}
 extension FX.NamespaceImplement where Base == Cls {
     ***
 }
**************/

/// 类型协议
public protocol TypeWrapperProtocol {
    associatedtype Base
    var base: Base { get }
    init(value: Base)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let base: T
    public init(value: T) {
        self.base = value
    }
}
/// 命名空间协议
public protocol NamespaceWrappable {
    associatedtype WrapperType
    var fx: WrapperType { get }
    static var fx: WrapperType.Type { get }
}

extension NamespaceWrappable {
    public var fx: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    public static var fx: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

/* 示例
 extension UIColor: NamespaceWrappable {}
 extension TypeWrapperProtocol where Base == UIColor {
 /// 用自身颜色生成UIImage
 var image: UIImage? {
 let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
 UIGraphicsBeginImageContext(rect.size)
 let context = UIGraphicsGetCurrentContext()
 context?.setFillColor(wrappedValue.cgColor)
 context?.fill(rect)
 let image = UIGraphicsGetImageFromCurrentImageContext()
 return image
 }
 }
 func test() {
 UIColor().fx.image
 }
 */

///FX命令空间
public struct FX {}
extension FX {
    public typealias NamespaceDefine = NamespaceWrappable
    public typealias NamespaceImplement = TypeWrapperProtocol
}
/* 示例
 extension UIColor: FX.NamespaceDefine {}
 extension FX.NamespaceImplement where Base == UIColor {
 var test:UIImage? {
 return nil
 }
 }
*/
