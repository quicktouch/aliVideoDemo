//
//  FileUploadViewController.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/27.
//

import AVFoundation
import Foundation
import SVProgressHUD
import UIKit

protocol FileUploadPresentableListener: class {
    func accessVedioKey(success: @escaping (VideoUpload) -> Void, failed: @escaping (String) -> Void)
    func updateVedioKey(videoId: String, success: @escaping (VideoUpload) -> Void, failed: @escaping (String) -> Void)
}

final class FileUploadViewController: UIViewController, FileUploadPresentable, FileUploadControllable, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var listener: FileUploadPresentableListener
    var client: VODUploadClient = VODUploadClient()

    init() {
        let router = FileUploadRouter()
        let interactor = FileUploadInteractor(router: router)
        self.listener = interactor
        super.init(nibName: "FileUploadViewController", bundle: nil)
        router.setControllable(self)
        interactor.presenter = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not support")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initALiClient()
        self.accessKeys()
    }

    var videoUploadTokenModel: VideoUpload?

    private func accessKeys() {
        SVProgressHUD.show(withStatus: "获取上传地址和上传凭证")
        self.listener.accessVedioKey { model in
            self.videoUploadTokenModel = model
            SVProgressHUD.showSuccess(withStatus: "获取上传地址成功")
        } failed: { msg in
            SVProgressHUD.showError(withStatus: msg)
        }
    }

    private func initALiClient() {
        let listener = VODUploadListener()
        listener.finish = { fileInfo, result in
            DLog(fileInfo)
            DLog(result)
            SVProgressHUD.showSuccess(withStatus: "上传成功")
        }
        listener.failure = { fileInfo, code, message in
            /* UploadFileInfo* fileInfo, NSString *code, NSString * message */
            DLog(fileInfo)
            DLog(code)
            DLog(message)
        }
        listener.progress = { _, uploadSize, totalSize in
            SVProgressHUD.showProgress(Float(uploadSize / totalSize))
        }
        listener.expire = { [weak self] in
            if let videoId = self?.videoUploadTokenModel?.video_id {
                self?.listener.updateVedioKey(videoId: videoId, success: { item in
                    self?.client.resume(withAuth: item.upload_auth ?? "")
                }, failed: { _ in
                })
            }
        }
        listener.retry = {}
        listener.retryResume = {}
        listener.started = { [weak self] fileInfo in
            guard let model = self?.videoUploadTokenModel else {
                SVProgressHUD.showError(withStatus: "当前获取上传地址和凭证方式失败")
                return
            }
            self?.client.setUploadAuthAndAddress(fileInfo, uploadAuth: model.upload_auth ?? "", uploadAddress: model.upload_address ?? "")
        }
        self.client.setListener(listener)
    }

    @IBAction func chooseVideo(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.movie"]
        self.present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
    }

    func getCacheDirectoryPath() -> URL {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectoryPath = arrayPaths[0]
        return cacheDirectoryPath
    }

    // 视频选择回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL

        ////////////////////////////////////////////////////////////////

        // MARK: -

        // TODO: 优化为异步执行。 并且上传完成后移除temp.mp4

        // MARK: -

        let data = NSData(contentsOf: videoURL)
        if data!.length / 1024 / 1024 > 4 * 1024 { // 最大4g
            SVProgressHUD.showError(withStatus: "文件最大不能超过4G")
            return
        }
        let exportUrl = self.getCacheDirectoryPath().appendingPathComponent("temp.mp4")
        data?.write(to: exportUrl, atomically: false)

        let vodInfo = VodInfo()
        vodInfo.title = "上传完成测试"
        self.client.addFile(exportUrl.path, vodInfo: vodInfo)
        // self.client.addFile(videoURL.path, vodInfo: VodInfo()) 提示没有权限

        ////////////////////////////////////////////////////////////////

        self.client.start()
        self.dismiss(animated: true, completion: nil)

        /*
         ▿ 3 elements
           ▿ 0 : 2 elements
             ▿ key : UIImagePickerControllerInfoKey
               - _rawValue : UIImagePickerControllerMediaType
             - value : public.movie
           ▿ 1 : 2 elements
             ▿ key : UIImagePickerControllerInfoKey
               - _rawValue : UIImagePickerControllerMediaURL
             - value : file:///private/var/mobile/Containers/Data/PluginKitPlugin/688B5BDD-090D-4011-86BE-A12CA53D3588/tmp/trim.BA944180-583D-4959-AD14-A4A5A6038B22.MOV
           ▿ 2 : 2 elements
             ▿ key : UIImagePickerControllerInfoKey
               - _rawValue : UIImagePickerControllerReferenceURL
             - value : assets-library://asset/asset.MOV?id=0296FB56-5916-4F10-8AEE-D89423E2A941&ext=MOV
         */
    }
}
