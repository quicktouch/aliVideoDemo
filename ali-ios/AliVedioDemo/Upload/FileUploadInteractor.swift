//
//  FileUploadInteractor.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/27.
//

import Foundation

protocol FileUploadPresentable: class {
    var listener: FileUploadPresentableListener { get set }
}

protocol FileUploadRouting: ViewableRouting {
    // route相关的属性和方法
}

protocol FileUploadInteractable: class {
    var router: FileUploadRouting { get }
}

final class FileUploadInteractor: PresentableInteractor<FileUploadRouting>, FileUploadPresentableListener {
    weak var presenter: FileUploadPresentable?

    // MARK: -  FileUploadPresentableListener(View Call)

    func accessVedioKey(success: @escaping (VideoUpload) -> Void, failed: @escaping (String) -> Void) {
        let api = API.createVideo(name: "测试标题")
        Panda.requestModel(type: api) { (model: VideoUpload?, _) in
            if let model = model {
                success(model)
            } else {
                failed("")
            }
        } failure: { msg, _ in
            failed(msg)
        }
    }

    func updateVedioKey(videoId: String, success: @escaping (VideoUpload) -> Void, failed: @escaping (String) -> Void) {
        let api = API.videoRefresh(videoId: videoId)
        Panda.requestModel(type: api) { (model: VideoUpload?, _) in
            if let model = model {
                success(model)
            } else {
                failed("")
            }
        } failure: { msg, _ in
            failed(msg)
        }
    }
}
