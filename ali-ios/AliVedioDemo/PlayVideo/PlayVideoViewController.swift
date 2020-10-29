//
//  PlayVideoViewController.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/28.
//

import AliyunPlayer
import Foundation
import UIKit

protocol PlayVideoPresentableListener: class, AVPDelegate {
    // 声明 viewController 可以调用以执行业务逻辑的属性和方法，例如signIn（）。
}

final class PlayVideoController: UIViewController, PlayVideoPresentable, PlayVideoControllable {
    var listener: PlayVideoPresentableListener
    var videoItem: VideoItem

    let player = AliPlayer()

    init(item: VideoItem) {
        self.videoItem = item
        let router = PlayVideoRouter()
        let interactor = PlayVideoInteractor(router: router)
        self.listener = interactor
        super.init(nibName: nil, bundle: nil)
        router.setControllable(self)
        interactor.presenter = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not support")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "视频播放"
        self.player?.playerView = self.view
        self.player?.delegate = self.listener
//        let source = AVPVidAuthSource.init(vid: videoItem.VideoId,
//                                           playAuth: <#T##String!#>,
//                                           region: <#T##String!#>)
    }
}
