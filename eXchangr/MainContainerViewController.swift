//
//  MainContainerViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/30/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    var main: UINavigationController?
    var menu: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMenuNotification(_:)), name: "showMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(removeMenuNotification(_:)), name: "removeMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pushControllerAndRemoveMenuNotification(_:)), name: "pushControllerAndRemoveMenu", object: nil)
    }

    func showMenuNotification(notification: NSNotification) {
        if let menuController = notification.userInfo?["menuController"] as? UIViewController {
            showMenuController(menuController)
        }
    }

    func removeMenuNotification(notification: NSNotification) {
        removeMenuViewController()
    }

    func pushControllerAndRemoveMenuNotification(notification: NSNotification) {
        removeMenuNotification(notification)
        if let targetController = notification.userInfo?["targetController"] as? UIViewController {
            main?.pushViewController(targetController, animated: true)
        } else {
            fatalError("Could not downcast _targetController to UIViewController")
        }
    }

    func setMainViewController(controller: UINavigationController) {
        if main != nil {
            removeMainViewController()
            main = nil
        }

        self.addChildViewController(controller)
        controller.view.frame = self.view.frame
        self.view.insertSubview(controller.view, atIndex: 0)
        controller.didMoveToParentViewController(self)
    }

    func showMenuController(menuController: UIViewController) {
        if menu != nil {
            removeMenuViewController()
        }

        self.addChildViewController(menuController)
        menuController.view.frame = makeHidenMenuViewControllerFrame()
        self.view.addSubview(menuController.view)
        menuController.didMoveToParentViewController(self)
    }

    func makeHidenMenuViewControllerFrame() -> CGRect {
        let width = self.view.frame.width * 0.6
        let height = self.view.frame.height
        let origin = CGPoint(x: 0, y: 0)
        let size = CGSize(width: width, height: height)
        return CGRect(origin: origin, size: size)
    }

    func removeMainViewController() {
        main?.willMoveToParentViewController(nil)
        main?.view.removeFromSuperview()
        main?.removeFromParentViewController()
        main = nil
    }

    func removeMenuViewController() {
        menu?.willMoveToParentViewController(nil)
        menu?.view.removeFromSuperview()
        menu?.removeFromParentViewController()
        menu = nil
    }
}
