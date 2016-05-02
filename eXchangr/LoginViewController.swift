//
//  LoginViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UserAuthenticationObserver, UITextFieldDelegate {

    var mainStoryboard: UIStoryboard!

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var newUserLabel: UILabel!
    @IBOutlet weak var createAnAccountButton: UIButton!

    @IBOutlet weak var usernameXConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordXConstraint: NSLayoutConstraint!
    @IBOutlet weak var appLabelYConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
        usernameField.delegate = self

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))

        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        ServerInterface.sharedInstance.addUserAuthenticationObserver(self)
    }

    func viewTapped(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }

    func hideKeyboard() {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === usernameField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        usernameXConstraint.constant = 0
        passwordXConstraint.constant = 0
        appLabelYConstraint.constant = -130
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)

        UIView.animateWithDuration(0.5, delay: 0.6, options: [], animations: {
            self.loginButton.alpha = 1
            self.newUserLabel.alpha = 1
            self.createAnAccountButton.alpha = 1
            }, completion: {
                success in
                self.usernameField.becomeFirstResponder()
        })
    }


    // Shows navigation bar for other views, at the moment that this view will disappear
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        prepareForAnimation()
    }

    // Hides navigation bar from login view, at the moment that this view will appear
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        prepareForAnimation()
        feedbackLabel.hidden = true
    }

    func prepareForAnimation() {
        usernameXConstraint.constant = -500
        passwordXConstraint.constant = 500
        appLabelYConstraint.constant = -500
        loginButton.alpha = 0
        newUserLabel.alpha = 0
        createAnAccountButton.alpha = 0
    }

    @IBAction func registerNewUserTapped(sender: AnyObject) {
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("NewUserViewController") as! UserRegistrationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func LoginUserTapped(sender: AnyObject) {
        hideKeyboard()
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
