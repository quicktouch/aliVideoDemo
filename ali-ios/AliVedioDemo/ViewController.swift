//
//  ViewController.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/26.
//

import RxSwift
import UIKit
class ViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 上传
            let upload = FileUploadViewController()
            self.navigationController?.pushViewController(upload, animated: true)
        }
        if indexPath.row == 1 {
            let list = VideoListController()
            self.navigationController?.pushViewController(list, animated: true)
        }
    }
}
