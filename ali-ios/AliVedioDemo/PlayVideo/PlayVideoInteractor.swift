//
//  PlayVideoInteractor.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/28.
//

import AliyunPlayer
import Foundation

protocol PlayVideoPresentable: class {
    var listener: PlayVideoPresentableListener { get set }
}

protocol PlayVideoRouting: ViewableRouting {
    // route相关的属性和方法
}

protocol PlayVideoInteractable: class {
    var router: PlayVideoRouting { get }
}

final class PlayVideoInteractor: PresentableInteractor<PlayVideoRouting>, PlayVideoPresentableListener {
    weak var presenter: PlayVideoPresentable?

    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {}

    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        DLog(eventType)
    }
}
