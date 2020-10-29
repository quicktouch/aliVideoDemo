//
//  Panda+CommonModel.swift
//  NanningIndustry
//
//  Created by TYRAD on 2018/6/7.
//  Copyright © 2018年 quicktouch. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import Result
import SwiftyJSON

extension Panda {
    static func requestCommonModel<T: Mappable, R: TargetType>(
        type: R,
        progress: ProgressBlock? = nil,
        useStub: Bool = false,
        success: @escaping ((T?) -> Void),
        failure: @escaping ((String, _ statusCode: Int?) -> Void)
    ) -> Cancellable {
        let provider = generateDefaultProvider(type, useStub)

        return provider.request(type, progress: progress, completion: { result in

            handleCommonModelCompletion(result: result, failure: failure, modelCmd: { (data: Data) in

                if let json = String(data: data, encoding: .utf8) {
                    let object = Mapper<T>().map(JSONString: json) // mapperModel.map(JSONString: json)
                    success(object)
                } else {
                    success(nil)
                }
            })
        })
    }

    static func handleCommonModelCompletion(
        result: Result<Moya.Response, MoyaError>,
        failure: @escaping ((String, _ statusCode: Int?) -> Void),
        modelCmd: (_ data: Data) -> Void
    ) {
        switch result {
        case let .success(response):

            do {
                _ = try response.filterSuccessfulStatusCodes()
                if PandaParameter.isDebug == true {
                    let json = try JSON(response.mapJSON())
                    DLog(json.description)
                }
                // 回调处理model的方法
                modelCmd(response.data)
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
}
