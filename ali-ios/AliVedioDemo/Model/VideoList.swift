//
//  VideoList.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/28.
//

import Foundation
import ObjectMapper

// ---Snapshots---
struct Snapshots: Mappable {
    var Snapshot: [String]?
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        Snapshot <- map["Snapshot"]
    }
}

// ---VideoItems---
struct VideoItem: Mappable {
    var VideoId: String?
    var Title: String?
    var Tags: String?
    var Status: String?
    var Size: Float?
    var Duration: Float?
    var Description: String?
    var CreateTime: String?
    var ModifyTime: String?
    var ModificationTime: String?
    var CreationTime: String?
    var CoverURL: String?
    var CateId: Float?
    var CateName: String?
    var StorageLocation: String?
    var AppId: String?
    var Snapshots: Snapshots?
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        VideoId <- map["VideoId"]
        Title <- map["Title"]
        Tags <- map["Tags"]
        Status <- map["Status"]
        Size <- map["Size"]
        Duration <- map["Duration"]
        Description <- map["Description"]
        CreateTime <- map["CreateTime"]
        ModifyTime <- map["ModifyTime"]
        ModificationTime <- map["ModificationTime"]
        CreationTime <- map["CreationTime"]
        CoverURL <- map["CoverURL"]
        CateId <- map["CateId"]
        CateName <- map["CateName"]
        StorageLocation <- map["StorageLocation"]
        AppId <- map["AppId"]
        Snapshots <- map["Snapshots"]
    }
}

// ---Videolist---
struct VideoItems: Mappable {
    var Video: [VideoItem]?
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        Video <- map["Video"]
    }
}

// ---Data---
struct VideoPages: Mappable {
    var RequestId: String?
    var Total: Float?
    var VideoList: VideoItems?
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        RequestId <- map["RequestId"]
        Total <- map["Total"]
        VideoList <- map["VideoList"]
    }
}
