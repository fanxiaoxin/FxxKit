//
//  DefaultLocalized.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/20.
//

import UIKit

///使用系统多语言文件管理
open class FXLocalizedManager: FXLocalizedManagerType {
    public typealias ProviderType = FXLocalizedProvider
    
    public let targets = FXWeakerSet()
    ///当前使用的资源
    public var provider: FXLocalizedProvider? {
        didSet {
            self.apply()
        }
    }
    ///多语言文件名
    public var table: String
    ///获取当前系统支持的语言
    open var languages: [String] {
        return Bundle.main.localizations
    }
    ///获取或设置当前语言(须存在于languages列表中)
    open var currentLanguage: String? = nil {
        didSet {
            self.__loadProvider()
            self.__storgeCurrentLanguage(self.currentLanguage)
        }
    }
    public init(table: String) {
        self.table = table
        self.currentLanguage = self.__storgedCurrentLanguage() ?? Bundle.main.preferredLocalizations.first ?? self.languages.first
        self.__loadProvider()
//        self.apply()
    }
    func __loadProvider() {
        if let l = self.currentLanguage {
            self.provider = FXLocalizedProvider(language:l, table: self.table)
        }else{
            self.provider = nil
        }
    }
    func __storgeCurrentLanguage(_ value: String?) {
        UserDefaults.standard.set(value, forKey: "__FXLocalizedManager.currentLanguage")
        UserDefaults.standard.synchronize()
    }
    func __storgedCurrentLanguage() -> String? {
        return UserDefaults.standard.string(forKey: "__FXLocalizedManager.currentLanguage")
    }
}
///使用系统多语言文件管理
open class FXLocalizedProvider: FXLocalizedProviderType {
    let bundle: Bundle
    var table: String
    public init?(language: String, table: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            self.bundle = bundle
            self.table = table
        }else{
            return nil
        }
    }
    public subscript(index: String) -> String {
        return self.bundle.localizedString(forKey: index, value: nil, table: self.table)
    }
}
