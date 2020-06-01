//
//  JsonApiSerializer.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/5.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import HandyJSON

///API请求参数格式化
public protocol FXApiParametersFomatterType {
    func format(api:FXApiType) -> [String:Any]?
}
public protocol FXApiResponseType: HandyJSON {
    ///判断当前接口数据是否失败，若为nil才会去取数据及列表字段
    var error: Error? { get }
}
public protocol FXApiListResponseType: FXApiResponseType {
    associatedtype ModelType: HandyJSON
    ///返回列表数据
    var list: [ModelType]? { get }
}
public protocol FXApiPagedListResponseType: FXApiListResponseType {
    ///返回是否列表是否已到底
    var isEnd: Bool { get }
}
///API列表请求结构
public protocol FXApiPagedListRequestType: HandyJSON {
    ///返回是否列表是否已到底
    var pageSize: Int { get set }
    var pageNumber: Int { get set }
}
