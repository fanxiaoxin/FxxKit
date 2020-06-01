//
//  URLExtension.swift
//  Alamofire
//
//  Created by Fanxx on 2019/8/1.
//

import UIKit

extension FX.NamespaceImplement where Base == URL {
    public func byAppend(query name:String, value: String) -> URL {
        if var cp = URLComponents(url: self.base, resolvingAgainstBaseURL: false) {
            let item = URLQueryItem(name: name, value: value)
            if var items = cp.queryItems {
                if var fisrt = items.first(where: { $0.name == name }) {
                    fisrt.value = value
                }else{
                    items.append(item)
                }
            }else{
                cp.queryItems = [item]
            }
            return cp.url!
        }else{
            return self.base
        }
    }
    ///通过外部浏览器打开
    public func open() {
        if #available(iOS 10.0, *) {
            //系统版本高于10.0
            UIApplication.shared.open(self.base, options: [:], completionHandler: nil)
        } else {
            //系统版本低于10.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
                UIApplication.shared.openURL(self.base)
            }
        }
    }
}

