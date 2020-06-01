//
//  UIWebViewExtension.swift
//  FXKit
//
//  Created by Fanxx on 2018/4/8.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit
import WebKit

extension FX.NamespaceImplement where Base: UIWebView {
    public static func add(userAgent:String) {
        // 获取 iOS 默认的 UserAgent，可以很巧妙地创建一个空的UIWebView来获取：
        if let oua = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent"){
            let customUserAgent = oua.appendingFormat(" %@", userAgent)
            UserDefaults.standard.register(defaults: ["UserAgent":customUserAgent])
        }
    }
}
