//
//  VideoListViewController.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/28.
//

import Foundation
import SnapKit
import UIKit

protocol VideoListPresentableListener: class, UITableViewDelegate, UITableViewDataSource {
    var videoItems: [VideoItem] { get set }
    var tableView: UITableView? { get set }
    func reloadList()
}

final class VideoListController: UIViewController, VideoListPresentable, VideoListControllable {
    var listener: VideoListPresentableListener

    init() {
        let router = VideoListRouter()
        let interactor = VideoListInteractor(router: router)
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
        let tableView = UITableView()
        view.addSubview(tableView)
        listener.tableView = tableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.delegate = listener
        tableView.dataSource = listener
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        listener.reloadList()
    }

    // MARK: - VideoListPresentable (Interactor Call)

    // MARK: - VideoListControllable (Router Call)
}
