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

    var blurOverlay = UIView()

    let menuAnimationDuration: NSTimeInterval = 0.4
    let menuAnimationDelay: NSTimeInterval = 0.0
    let damping: CGFloat = 0.85
    let startSpeed: CGFloat = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        configureBlurOverlay()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMenuNotification), name: "showMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(removeMenuNotification), name: "removeMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pushControllerAndRemoveMenuNotification), name: "pushControllerAndRemoveMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(performUserLogoutNotification), name: "performUserLogout", object: nil)
    }

    func configureBlurOverlay() {
        blurOverlay.alpha = 0.0
        blurOverlay.hidden = true
        blurOverlay.frame = view.frame
        blurOverlay.backgroundColor = UIColor.clearColor()
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurOverlay.frame
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurOverlay.addSubview(blurEffectView)

        blurOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blurTap)))
    }

    func blurTap(sender: UITapGestureRecognizer) {
        removeMenuViewController()
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

    func performUserLogoutNotification(notification: NSNotification) {
        removeMenuNotification(notification)
        main?.popToRootViewControllerAnimated(true)
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
        main = controller
    }

    func showMenuController(menuController: UIViewController) {
        if menu != nil {
            removeMenuViewController()
        }

        self.addChildViewController(menuController)
        menuController.view.frame = makeHidenMenuViewControllerFrame()

        self.view.addSubview(menuController.view)
        self.blurOverlay.hidden = false
        self.view.insertSubview(self.blurOverlay, belowSubview: menuController.view)

        menuController.didMoveToParentViewController(self)
        menu = menuController

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(menuSwipe))
        swipeRecognizer.direction = .Left
        menu!.view.addGestureRecognizer(swipeRecognizer)
        animateMenu(origin: 0, completionHandler: nil)
    }

    func menuSwipe(sender: UISwipeGestureRecognizer) {
        removeMenuViewController()
    }

    func makeHidenMenuViewControllerFrame() -> CGRect {
        let width = self.view.frame.width * 0.5
        let height = self.view.frame.height
        let origin = CGPoint(x: -width, y: 0)
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
        menu!.willMoveToParentViewController(nil)
        animateMenu(origin: -menu!.view.frame.width) {
            (completed) in
            self.menu!.view.removeFromSuperview()
            self.menu!.removeFromParentViewController()
            self.menu = nil
            self.blurOverlay.hidden = true
            self.blurOverlay.removeFromSuperview()
        }
    }

    func animateMenu(origin origin: CGFloat ,completionHandler: ((Bool) -> ())?) {
        UIView.animateWithDuration(self.menuAnimationDuration, delay: self.menuAnimationDelay, usingSpringWithDamping: self.damping, initialSpringVelocity: self.startSpeed, options: [], animations: {
            self.menu!.view.frame.origin.x = origin
            
            self.blurOverlay.alpha = 1 - self.blurOverlay.alpha
            }, completion: completionHandler)
    }
}
