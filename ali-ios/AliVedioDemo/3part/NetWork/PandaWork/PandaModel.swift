//
//  Model.swift
//  3rdDebugger
//
//  Created by TYRAD on 2018/4/12.
//  Copyright © 2018年 chen. All rights reserved.
//

import Foundation
import ObjectMapper

class PandaBaseModel<T: Mappable>: Mappable {
    var code: String?
    var msg: String?
    var data: T?

    required init?(map _: Map) {
    }

    func codeIntValue() -> Int {
        return ((code ?? "") as NSString).integerValue
    }

    func mapping(map: Map) {
        code <- map[PandaParameter.code]
        msg <- map[PandaParameter.msg]
        data <- map[PandaParameter.data]
    }
}

class PandaBase<T>: Mappable {
    var code: String?
    var msg: String?
    var data: T?

    required init?(map _: Map) {
    }

    func codeIntValue() -> Int {
        return ((code ?? "") as NSString).integerValue
    }

    func mapping(map: Map) {
        code <- map[PandaParameter.code]
        msg <- map[PandaParameter.msg]
        data <- map[PandaParameter.data]
    }
}

class PandaListModel<T: Mappable>: Mappable {
    var code: String?
    var msg: String?
    var dataList: [T]?

    required init?(map _: Map) {
    }

    func mapping(map: Map) {
        code <- map[PandaParameter.code]
        msg <- map[PandaParameter.msg]
        dataList <- map[PandaParameter.data]
    }
}

struct PandaModelTool {

    // 基本类型数据的转换, 如字典
    static func singleType<T>(_ Json: Data) -> PandaBase<T>? {
        let mapperModel = Mapper<PandaBase<T>>()
        if let json = String(data: Json, encoding: .utf8) {
            let object = mapperModel.map(JSONString: json)
            return object
        }
        return nil
    }

    // Object类型数据转换
    static func objectFromJSON<T: Mappable>(_ Json: Data) -> PandaBaseModel<T>? {
        let mapperModel = Mapper<PandaBaseModel<T>>()
        if let json = String(data: Json, encoding: .utf8) {
            let object = mapperModel.map(JSONString: json)
            return object
        }
        return nil
    }

    // Object List 类型数据转换
    static func listFromJSON<T: Mappable>(_ Json: Data) -> PandaListModel<T>? {
        let mapperModel = Mapper<PandaListModel<T>>()
        if let json = String(data: Json, encoding: .utf8) {
            let object = mapperModel.map(JSONString: json)
            return object
        }
        return nil
    }
}
