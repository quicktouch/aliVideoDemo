//
//  MoyaPlugin.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Moya
import Result

/// 指示器
final class RequestAlertPlugin: PluginType {
    init() {}

    func willSend(_: RequestType, target _: TargetType) {
        DispatchQueue.main.async { () -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func didReceive(_: Result<Response, MoyaError>, target _: TargetType) {
        DispatchQueue.main.async { () -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

// JWT
class TokenSource {
    var token: String {
        return ""
    }

    init() {}
}

protocol AuthorizedTargetType: TargetType {
    // 给moya枚举使用,表示哪些请求需要token
    var needsAuth: Bool { get }
}

struct AuthorizationPlugin: PluginType {
    let tokenClosure: () -> String?

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let _ = tokenClosure(),
            let target = target as? AuthorizedTargetType,
            target.needsAuth
        else {
            return request
        }
        //...
        return request
    }
}

/// Network activity change notification type.
public enum NetworkActivityChangeType {
    case began, ended
}

/// Notify a request's network activity changes (request begins or ends).
public final class NetworkActivityPlugin: PluginType {
    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType) -> Void
    let networkActivityClosure: NetworkActivityClosure

    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }

    // MARK: Plugin

    /// Called by the provider as soon as the request is about to start
    public func willSend(_: RequestType, target _: TargetType) {
        networkActivityClosure(.began)
    }

    /// Called by the provider as soon as a response arrives, even if the request is canceled.
    public func didReceive(_: Result<Moya.Response, MoyaError>, target _: TargetType) {
        networkActivityClosure(.ended)
    }
}
