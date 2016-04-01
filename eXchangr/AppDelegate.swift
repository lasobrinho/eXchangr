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
        ServerInterface.sharedInstance.connect()
        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        ServerInterface.sharedInstance.connect()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        ServerInterface.sharedInstance.disconnect()
    }

}