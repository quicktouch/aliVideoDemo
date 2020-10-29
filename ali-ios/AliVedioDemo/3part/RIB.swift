//
//  RIBCore.swift
//  CommoniOS
//
//  Created by chen on 2020/9/25.
//  Copyright © 2020 quicktouch. All rights reserved.
//

import Foundation
import UIKit

protocol ViewableRouting: class {
    var viewControllable: ViewControllable? { get }
}

public protocol ViewControllable: class {
    var uiviewController: UIViewController { get }
    var navigationController: UINavigationController? { get }
    var view: UIView! { get }
}

public extension ViewControllable where Self: UIViewController {
    var uiviewController: UIViewController {
        return self
    }
}

open class PresentableInteractor<ViewableRouting>: NSObject {
    public let router: ViewableRouting
    public init(router: ViewableRouting) {
        self.router = router
    }
}

open class IBRouter<ViewControllerType> {
    public weak var viewControllable: ViewControllable?
    public var viewController: ViewControllerType {
        return self.viewControllable as! ViewControllerType
    }

    public func setControllable(_ controllable: ViewControllerType) {
        self.viewControllable = controllable as? ViewControllable
    }
}

func DLog<T>(_ message: T,
             file: String = #file,
             method: String = #function,
             line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
