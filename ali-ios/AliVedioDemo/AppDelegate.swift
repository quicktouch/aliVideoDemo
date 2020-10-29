//
//  AppDelegate.swift
//  AliVedioDemo
//
//  Created by chen on 2020/10/26.
//

import SVProgressHUD
import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        return true
    }
}
