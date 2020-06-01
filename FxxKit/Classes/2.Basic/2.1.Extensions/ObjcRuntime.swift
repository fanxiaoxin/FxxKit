//
//  ObjcRuntime.swift
//  FXKit
//
//  Created by Fanxx on 2019/4/19.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

extension FX.NamespaceImplement where Base: NSObject {
    //Strong nonatomic
    /*
    subscript<T>(index: String) -> T? {
        get {
            if let key = UnsafeRawPointer(bitPattern: index.hashValue) {
                return objc_getAssociatedObject(self.base, key) as? T
            }else{
                return nil
            }
        }
        set(newValue) {
            if let key = UnsafeRawPointer(bitPattern: index.hashValue) {
                objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }*/
    public func getAssociated<T>(object key: String) -> T? {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            return objc_getAssociatedObject(self.base, idx) as? T
        }else{
            return nil
        }
    }
    public func setAssociated<T>(object:T, key: String) {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            objc_setAssociatedObject(self.base, idx, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    public func setWeakAssociated<T>(object:T, key: String) {
        if let idx = UnsafeRawPointer(bitPattern: key.hashValue) {
            objc_setAssociatedObject(self.base, idx, object, .OBJC_ASSOCIATION_ASSIGN);
        }
    }
}
