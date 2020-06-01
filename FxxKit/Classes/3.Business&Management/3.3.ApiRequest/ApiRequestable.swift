//
//  ApiAccessable.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/26.
//

import UIKit
import Moya
import HandyJSON

public protocol FXApiRequestable {
    var defaultScheme: FXApiRequestSchemeType { get }
}
extension FXApiRequestable {
    ///调用接口
    @discardableResult
    public func request<ApiType: FXResponseApiType>(_ api: ApiType, scheme: FXApiRequestSchemeType? = nil, completion: ((ApiType.ResponseType) -> Void)? = nil) -> FXApiResultHandling<ApiType.ResponseType> {
        let handler = (scheme ?? self.defaultScheme).request(api)
        if let c = completion {
            handler.success(c)
        }
        return handler
    }
}
