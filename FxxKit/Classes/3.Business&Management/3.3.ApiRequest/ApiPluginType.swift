//
//  ApiPluginType.swift
//  Alamofire
//
//  Created by Fanxx on 2019/7/31.
//

import UIKit
import Moya
import Result

public protocol FXApiPluginType: PluginType {
    //只会接受FXResponseApiType, 其中responser的类型和FXResponseApiType的response一致
    func willReceive(_ response: Any, target: FXApiType)
    //只会接受FXResponseApiType, 其中responser的类型和FXResponseApiType的response一致
    func didReceive(_ response: Any, target: FXApiType)
}
extension FXApiPluginType {
    public func willReceive(_ response: Any, target: FXApiType) {}
    public func didReceive(_ response: Any, target: FXApiType) {}
}
