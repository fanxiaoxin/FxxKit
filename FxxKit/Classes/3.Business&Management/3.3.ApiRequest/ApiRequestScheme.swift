//
//  ApiRequestMethod.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/26.
//

import UIKit
import Moya

///API请求方案(包含API请求的所有额外参数，用于包装Provider及错误处理)
public protocol FXApiRequestSchemeType {
    ///回调队列
    var callbackQueue: DispatchQueue? { get }
    ///进度处理
    var progress: ProgressBlock? { get }
    ///错误处理
    func handle(error: Error, for api: FXApiType)
    ///Provider
    func provider<ApiType: FXApiType>(for api: ApiType) -> MoyaProvider<ApiType>
}

public class FXApiResultHandling<ResponseType> {
    public var successHandler: ((ResponseType) -> Void)?
    public var failureHandler: ((Error) -> Void)?
    ///如果返回false则不调用success和failure
    public var whateverHandler: (() -> Bool)?
    public internal(set) var canceller: Cancellable?
    
    @discardableResult
    public func success(_ handler: @escaping (ResponseType) -> Void) -> Self {
        self.successHandler = handler
        return self
    }
    @discardableResult
    public func failure(_ handler: @escaping (Error) -> Void) -> Self {
        self.failureHandler = handler
        return self
    }
    @discardableResult
    public func whatever(_ handler: @escaping () -> Bool) -> Self {
        self.whateverHandler = handler
        return self
    }
}

extension FXApiRequestSchemeType {
    ///回调队列
    public var callbackQueue: DispatchQueue? { return .none }
    ///进度处理
    public var progress: ProgressBlock? { return .none }
    ///错误处理
    public func handle(error: Error, for api: FXApiType) {}
    ///Provider
    public func provider<ApiType: FXApiType>(for api: ApiType) -> MoyaProvider<ApiType> {
        return MoyaProvider<ApiType>()
    }
    internal func mappingError(_ info:String) -> Error {
        return NSError(domain: "FXApiRequestSchemeType", code: 999, userInfo: [NSLocalizedDescriptionKey: info])
    }
    ///调用接口
    @discardableResult
    public func request<ApiType: FXResponseApiType>(_ api: ApiType) -> FXApiResultHandling<ApiType.ResponseType> {
        let provider = self.provider(for: api)
        let handling = FXApiResultHandling<ApiType.ResponseType>()
        handling.canceller = provider.request(api, callbackQueue: self.callbackQueue, progress: self.progress) { (result) in
            if handling.whateverHandler?() ?? true {
                switch result {
                case let .failure(error):
                    self.handle(error: error, for: api)
                    handling.failureHandler?(error)
                case let .success(response):
                    do {
                        if let json = try response.mapJSON() as? NSDictionary,
                            let s = ApiType.ResponseType.deserialize(from: json){
                            if let error = s.error {
                                self.handle(error: error, for: api)
                                handling.failureHandler?(error)
                            }else{
                                provider.plugins.forEach({ (pt) in
                                    if let p = pt as? FXApiPluginType {
                                        p.willReceive(s, target: api)
                                    }
                                })
                                handling.successHandler?(s)
                                provider.plugins.forEach({ (pt) in
                                    if let p = pt as? FXApiPluginType {
                                        p.didReceive(s, target: api)
                                    }
                                })
                            }
                        }else{
                            let err = MoyaError.underlying(self.mappingError("Api结构化失败"), response)
                            self.handle(error: err, for: api)
                            handling.failureHandler?(err)
                        }
                    }catch(let error) {
                        let err = MoyaError.underlying(error, response)
                        self.handle(error: err, for: api)
                        handling.failureHandler?(err)
                    }
                }
            }
        }
        
        return handling
    }
    ///下载比较特殊，不较验结构，若要校验则使用request方法
    @discardableResult
    public func download<ApiType: FXDownloadApiType>(_ target: ApiType) -> FXApiResultHandling<DownloadDestination> {
        let handling = FXApiResultHandling<DownloadDestination>()
        handling.canceller = self.provider(for: target).request(target, callbackQueue: self.callbackQueue, progress: self.progress) { (result) in
            if handling.whateverHandler?() ?? true {
                switch result {
                case let .failure(error) :
                    self.handle(error: error, for: target)
                    handling.failureHandler?(error)
                case .success(_):
                    handling.successHandler?(target.destination)
                }
            }
        }
        return handling
    }
}
///隐式调用API方案，无任何错误及调用过程处理，只有在成功时才会回调
public class FXImplicitApiRequestScheme: FXApiRequestSchemeType {
    public init() {}
}
