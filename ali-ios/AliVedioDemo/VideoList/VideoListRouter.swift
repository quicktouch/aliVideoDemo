//
//  VideoListRouter.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/28.
//

import Foundation
import UIKit

protocol VideoListControllable: ViewControllable {}

final class VideoListRouter: IBRouter<VideoListControllable>, VideoListRouting {
    func showDetail(item: VideoItem) {
        let playVideo = PlayVideoController(item: item)
        self.viewController.navigationController?.pushViewController(playVideo, animated: true)
    }
}
