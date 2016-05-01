//
//  LoginViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UserAuthenticationObserver {
    
    var mainStoryboard: UIStoryboard!
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        ServerInterface.sharedInstance.addUserAuthenticationObserver(self)
    }
    
    // Shows navigation bar for other views, at the moment that this view will disappear
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    // Hides navigation bar from login view, at the moment that this view will appear
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func update(result: UserAuthenticationResult) {
        switch result {
        case .Success:
            let vc = mainStoryboard.instantiateViewControllerWithIdentifier("BrowseViewController") as! BrowserViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case let .Failure(message):
            print(message)
        }
    }
    
    @IBAction func registerNewUserTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("NewUserViewController") as! UserRegistrationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LoginUserTapped(sender: AnyObject) {
        ServerInterface.sharedInstance.performUserAuthentication(email: usernameLabel.text!, password: passwordLabel.text!)
    }
}
