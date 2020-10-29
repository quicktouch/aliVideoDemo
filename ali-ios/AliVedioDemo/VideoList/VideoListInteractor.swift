//
//  VideoListInteractor.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/28.
//

import Foundation
import SVProgressHUD
import UIKit

protocol VideoListPresentable: class {
    var listener: VideoListPresentableListener { get set }
}

protocol VideoListRouting: ViewableRouting {
    // route相关的属性和方法
    func showDetail(item: VideoItem)
}

// TODO: 在模板中移除该方法
// protocol VideoListInteractable: class {
//    var router: VideoListRouting { get }
// }

final class VideoListInteractor: PresentableInteractor<VideoListRouting>, VideoListPresentableListener {
    weak var presenter: VideoListPresentable?
    weak var tableView: UITableView?

    var videoItems: [VideoItem] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = videoItems[indexPath.row]
        cell.textLabel?.text = item.Title
        cell.detailTextLabel?.text = item.Description
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = videoItems[indexPath.row]
        router.showDetail(item: item)
    }

    func reloadList() {
        let api = API.videoList(pageSize: 20, pageNo: 1)
        SVProgressHUD.show()
        Panda.requestModel(type: api) { (item: VideoPages?, msg) in
            SVProgressHUD.showSuccess(withStatus: msg)
            self.videoItems = item?.VideoList?.Video ?? []
            self.tableView?.reloadData()
        } failure: { msg, _ in
            SVProgressHUD.showError(withStatus: msg)
        }
    }
}
