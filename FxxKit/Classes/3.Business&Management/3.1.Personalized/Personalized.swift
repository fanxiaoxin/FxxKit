//
//  Personalized.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///需要个性化的操作
public protocol FXPersonalizable:class {
    
}
///个性化相关资源提供者
public protocol FXPersonalizedProviderType {
    ///应用到某个操作
    func apply(to target: FXPersonalizable)
}
///个性化管理器，可用于多语言或主题等个性化操作
public protocol FXPersonalizedManagerType: class {
    associatedtype ProviderType: FXPersonalizedProviderType
    var targets: FXWeakerSet { get }
    var provider: ProviderType? { get }
}
extension FXPersonalizedManagerType {
    ///注册需要多语言的目标，在语言变更和初始化时调用相关方法
    public func register(_ target: FXPersonalizable) {
        self.targets.append(target)
        if let provider = self.provider {
            provider.apply(to: target)
        }
    }
    ///应用当前个性化设置
    public func apply() {
        if let provider = self.provider {
            self.targets.forEach { (target: FXPersonalizable) in
                provider.apply(to: target)
            }
        }
    }
}
