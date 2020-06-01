//
//  BundleExtension.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/1.
//

import UIKit


extension FX.NamespaceImplement where Base : Bundle {
    ///对外版本号
    public var version: String {
        return self.base.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    ///构建版本号
    public var buildVersion: String {
        return self.base.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
