//
//  VideoUpload.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/27.
//

import Foundation
import ObjectMapper

struct VideoUpload: Mappable {
    var request_id: String?
    var video_id: String?
    var upload_address: String?
    var upload_auth: String?
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        request_id <- map["request_id"]
        video_id <- map["video_id"]
        upload_address <- map["upload_address"]
        upload_auth <- map["upload_auth"]
    }
}
