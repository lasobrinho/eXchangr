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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!
    
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
        feedbackLabel.hidden = true
    }
    
    @IBAction func registerNewUserTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("NewUserViewController") as! UserRegistrationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LoginUserTapped(sender: AnyObject) {
        if fieldsAreValid() {
            loginButton.enabled = false
            ServerInterface.sharedInstance.performUserAuthentication(email: usernameField.text!, password: passwordField.text!)
        } else {
            feedbackLabel.text = "Please provide your credentials."
            feedbackLabel.hidden = false
        }
    }

    func fieldsAreValid() -> Bool {
        return !(usernameField.text!.isEmpty || passwordField.text!.isEmpty)
    }

    func update(result: UserAuthenticationResult) {
        switch result {
        case .Success:
            let vc = mainStoryboard.instantiateViewControllerWithIdentifier("BrowseViewController") as! BrowserViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case let .Failure(message):
            feedbackLabel.text = message
            feedbackLabel.hidden = false
        }
        loginButton.enabled = true
    }
}
