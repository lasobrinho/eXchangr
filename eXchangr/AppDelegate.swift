//
//  AppDelegate.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 3/30/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //self.window = UIWindow()
        //self.window!.rootViewController = buildApplicationContainer()
        //self.window!.makeKeyAndVisible()
        return true
    }

    func buildApplicationContainer() -> UIViewController {
        let rootViewController = buildRootViewController()
        let appContainer = UINavigationController(rootViewController: rootViewController)
        appContainer.toolbarHidden = true
        appContainer.navigationBarHidden = true
        return appContainer
    }

    func buildRootViewController() -> UIViewController {
        let rootViewController = LoginViewController()
        return rootViewController
    }

    func applicationDidBecomeActive(application: UIApplication) {
        ServerInterface.sharedInstance.connect()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        ServerInterface.sharedInstance.disconnect()
    }

}