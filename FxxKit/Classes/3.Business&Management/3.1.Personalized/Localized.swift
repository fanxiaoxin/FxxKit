//
//  Localized.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///多语言操作
public protocol FXLocalizable: FXPersonalizable {
    ///设置多语言相关的显示
    func localize(for provider: FXLocalizedProviderType)
}
///特定类型的多语言操作
public protocol FXDesignedLocalizable: FXLocalizable {
    associatedtype ProviderType: FXLocalizedProviderType
    ///设置多语言相关的显示
    func localize(for provider: ProviderType)
}
extension FXDesignedLocalizable {
    public func localize(for provider: FXLocalizedProviderType) {
        if let p = provider as? ProviderType {
            self.localize(for: p)
        }
    }
}
///多语言相关资源提供者
public protocol FXLocalizedProviderType: FXPersonalizedProviderType {
    ///获取对应键的文字
    subscript(index: String) -> String { get }
}
extension FXLocalizedProviderType {
    ///应用到某个操作
    public func apply(to target: FXPersonalizable) {
        if let t = target as? FXLocalizable {
            t.localize(for: self)
        }
    }
}
///多语言操作管理器
public protocol FXLocalizedManagerType: FXPersonalizedManagerType where ProviderType: FXLocalizedProviderType {
    
}
extension FXLocalizedManagerType {
    public subscript(index: String) -> String {
        return self.provider?[index] ?? ""
    }
}
