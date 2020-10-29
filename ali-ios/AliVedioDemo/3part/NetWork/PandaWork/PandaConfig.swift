//
//  NetworConfig.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Alamofire
import Foundation
import Moya

public let PandaParameter = PandaConfig()

public class PandaConfig {
    public let succ = "success"

    /// 返回文字提示
    public let msg = "msg"

    /// 返回code
    public let code = "code"

    /// 返回数据集合
    public let data = "data"

    /// 表示返回数据正常的
    public let successCode = 0
        
    /// hud上显示错误信息
    public let SHOW_ERROR = 10001
    
    public let SHOW_LOGIN = 2001

//    /// 表示登录过期
//    public let TOKEN_EXPIRED = 4406
//
//    /// 表示用户在别处登录
//    public let LOGIN_ELSE_WHERE = 4405

//    /**
//     * 未登录
//     */
//    public let UNAUTHEN = 4401
//
//    /**
//     * 未授权，拒绝访问(没有访问权限)
//     */
//    public final static int UNAUTHZ = 4403;
//
//    /**
//     * 未找到
//     */
//    public final static int NOT_FOUND = 4404;
//
//    /**
//     * (新增,用户被挤掉或者token过期)表示需要重新登录
//     */
//    public final static int RE_LOGIN = 4405;

    // Debug
    public var isDebug = true
    // header认证
    public var needAuthorization = true
    public var header = [String: String]()
    public var sessionManager = DefaultAlamofireManager.sharedManager
}

public class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 60
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
