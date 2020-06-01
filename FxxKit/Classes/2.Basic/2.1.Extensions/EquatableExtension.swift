//
//  EnumExtension.swift
//  FXKit
//
//  Created by Fanxx on 2019/5/22.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import Foundation

extension Equatable {
    ///判断是否判定枚举的其中一个
    public func `in`(_ values: Self...) -> Bool {
        return values.contains(self)
    }
}

