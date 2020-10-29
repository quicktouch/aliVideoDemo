//
//  API.swift
//  NanningIndustry
//
//  Created by TYRAD on 2018/4/18.
//  Copyright © 2018年 quicktouch. All rights reserved.
//

import Foundation
import Moya

enum API {
    case createVideo(name: String)
    case videoRefresh(videoId: String)
    case videoList(pageSize: Int, pageNo: Int)
}

extension API: TargetType, AuthorizedTargetType {
    var baseURLString: String {
        return "http://10.68.141.141:9000"
    }

    var baseURL: URL {
        return URL(string: baseURLString)!
    }

    var path: String {
        switch self {
        case .createVideo:
            return "/alive/createVideo"
        case .videoRefresh:
            return "/alive/videoRefresh"
        case .videoList:
            return "/alive/getVideoList"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .createVideo(name: let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        case .videoRefresh(videoId: let videoId):
            return .requestParameters(parameters: ["videoId": videoId], encoding: URLEncoding.default)
        case .videoList(pageSize: let pageSize, pageNo: let pageNo):
            return .requestParameters(parameters: ["pageSize": pageSize, "pageNo": pageNo], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var needsAuth: Bool {
        return false
    }

    var sampleData: Data {
        return """
        {}
        """.utf8Encoded
    }
}

// MARK: - Helpers

private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

private func jsonToData(jsonDic: [String: Any]) -> Data? {
    if !JSONSerialization.isValidJSONObject(jsonDic) {
        print("is not a valid json object")
        return nil
    }
    // 利用自带的json库转换成Data
    // 如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
    let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
    // Data转换成String打印输出
    let str = String(data: data!, encoding: String.Encoding.utf8)
    // 输出json字符串
    DLog("Json Str:\(str!)")
    return data
}
