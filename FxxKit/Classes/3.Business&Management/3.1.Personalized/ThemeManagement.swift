//
//  ThemeManagement.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///主题应用操作
public protocol FXThemeizable: FXPersonalizable {
    ///应用主题
    func apply(theme: FXThemeType)
}
///特定类型的多语言操作
public protocol FXDesignedThemeizable: FXThemeizable {
    associatedtype ThemeType: FXThemeType
    func apply(theme: ThemeType)
}
extension FXDesignedThemeizable {
    public func apply(theme: FXThemeType) {
        if let t = theme as? ThemeType {
            self.apply(theme: t)
        }
    }
}
///主题
public protocol FXThemeType: FXPersonalizedProviderType {
    ///获取对应键的颜色
    subscript(index: String) -> UIColor { get }
}
extension FXThemeType {
    ///应用到某个操作
    public func apply(to target: FXPersonalizable) {
        if let t = target as? FXThemeizable {
            t.apply(theme: self)
        }
    }
}
///主题管理器，负责切换主题等操作
public protocol FXThemeManagerType: FXPersonalizedManagerType where ProviderType: FXThemeType {
    
}
