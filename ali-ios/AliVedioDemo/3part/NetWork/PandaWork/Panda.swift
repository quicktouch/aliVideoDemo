//
//  NetWork.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import Result
import SwiftyJSON

struct Panda {
    /// 默认的Provider
    public static func generateDefaultProvider<T: TargetType>(_ target: T, _ needStub: Bool) -> MoyaProvider<T> {
        // endpointClosure
        let endpointClosure = { (target: T) -> Endpoint in
            MoyaProvider<T>.defaultEndpointMapping(for: target)
        }

        // MoyaProvider.immediatelyStub
        let stubClosure = MoyaProvider<T>.immediatelyStub

        // plugin
        var plugins: [PluginType] = [
            RequestAlertPlugin(),
        ]
        if PandaParameter.needAuthorization {
            plugins.append(AuthorizationPlugin(tokenClosure: { () -> String? in
                TokenSource().token
            }))
        }
        if PandaParameter.isDebug {
            plugins.append(NetworkLoggerPlugin(verbose: true))
            plugins.append(NetworkActivityPlugin(networkActivityClosure: { type in
                switch type {
                case .began: DLog("====>")
                case .ended: DLog("<====")
                }
            })
            )
        }

        if needStub == false {
            return MoyaProvider<T>(
                endpointClosure: endpointClosure,
                manager: PandaParameter.sessionManager,
                plugins: plugins
            )
        } else {
            return MoyaProvider<T>(
                endpointClosure: endpointClosure,
                stubClosure: stubClosure,
                manager: PandaParameter.sessionManager,
                plugins: plugins
            )
        }
    }

    static func requestSingle<R: TargetType>(
        type: R,
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((_: Data, _ msg: String) -> Void),
        failure: @escaping ((String, _ statusCode: Int?) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub)
        return provider.request(type, progress: progress, completion: { result in
            handleCompletion(result: result, failure: failure, modelCmd: success)
        })
    }

    @discardableResult
    static func requestModel<T: Mappable, R: TargetType>(
        type: R,
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((T?, _ msg: String) -> Void),
        failure: @escaping ((String, _ statusCode: Int?) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub)
        return provider.request(type, progress: progress, completion: { result in
            handleCompletion(result: result, failure: failure, modelCmd: { (data: Data, msgStr: String) in
                success(PandaModelTool.objectFromJSON(data)?.data, msgStr)
            })
        })
    }

    static func request<T, R: TargetType>(
        type: R,
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((T?, _ msg: String) -> Void),
        failure: @escaping ((String, _ statusCode: Int?) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub)
        return provider.request(type, progress: progress, completion: { result in
            handleCompletion(result: result, failure: failure, modelCmd: { (data: Data, msgStr: String) in
                success(PandaModelTool.singleType(data)?.data, msgStr)
            })
        })
    }

    static func requestModelList<T: Mappable, R: TargetType>(
        type: R,
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping (([T]?, _ msg: String) -> Void),
        failure: @escaping ((String, _ statusCode: Int?) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub)
        return provider.request(type, progress: progress, completion: { result in
            handleCompletion(result: result, failure: failure, modelCmd: { (data: Data, msgStr: String) in
                success(PandaModelTool.listFromJSON(data)?.dataList, msgStr)
            })
        })
    }

    private static func handleCompletion(
        result: Result<Moya.Response, MoyaError>,
        failure: @escaping ((String, _ statusCode: Int?) -> Void),
        modelCmd: (_ data: Data, _ msgStr: String) -> Void
    ) {
        switch result {
        case let .success(response):
            do {
                _ = try response.filterSuccessfulStatusCodes()
                let json = try JSON(response.mapJSON())

                if PandaParameter.isDebug == true {
                    DLog(json.description)
                }
                let code = json[PandaParameter.code].intValue
                let msgStr = json[PandaParameter.msg].stringValue
                guard code == PandaParameter.successCode /* json[PandaParameter.succ].boolValue */ else {
                    // if code == PandaParameter.TOKEN_EXPIRED || code == PandaParameter.LOGIN_ELSE_WHERE || code == PandaParameter.UNAUTHEN {
                    //    Noti.post(.loginExpiredRelogin, msgStr)
                    // }
                    /*
                     if code == PandaParameter.SHOW_LOGIN { //"用户未登录，请先登录"
                         SVProgressHUD.showError(withStatus: "用户未登录,请先登录")
                         //清空用户数据
                         UserInfo.shared.clearUserinfo()
                         if let controller = UIApplication.appTopViewController() {
                             let loginVC = BaseNavigationController(rootViewController: LoginViewController())
                             controller.present(loginVC, animated: true, completion: nil)
                         }
                     }
                     if code == PandaParameter.SHOW_ERROR {
                         SVProgressHUD.showError(withStatus: msgStr)
                     }
                     */
                    failure(msgStr, code)
                    return
                }
                // 回调处理model的方法
                modelCmd(response.data, msgStr)
            } catch let errors {
                failure(
                    mapErrorString(error: errors as! MoyaError),
                    (errors as NSError).code
                )
            }

        // 请求失败
        case let .failure(error):
            failure(error.errorDescription ?? "", (error as NSError).code)
        }
    }

    public static func mapErrorString(error: MoyaError) -> String {
        // 目前只考虑中文
        switch error {
        case .imageMapping:
            return "图片解析失败"
        case .jsonMapping:
            return "json解析失败"
        case .stringMapping:
            return "字符串解析失败"
        case .objectMapping:
            return "Decodable Error"
        case .encodableMapping:
            return "Encodable Error"
        case let .statusCode(response):
            return "请求失败 statusCode:\(response.statusCode)"
        case .underlying:
            return "Failed to map Endpoint to a URLRequest."
        case .requestMapping:
            return "Failed to encode parameters for URLRequest."
        case .parameterEncoding:
            return error.localizedDescription
        }
        // return error.errorDescription ??  "未知错误"
    }
}
