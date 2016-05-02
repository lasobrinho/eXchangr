//
//  UserRegistrationViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class UserRegistrationViewController: UIViewController, UserRegistrationObserver, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var registrationBtn: UIButton!

    var mainStoryboard: UIStoryboard!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))

        ServerInterface.sharedInstance.addUserRegistrationObserver(self)
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            ServerInterface.sharedInstance.removeUserRegistrationObserver(self)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func update(result: UserRegistrationResult) {
        switch result {
        case .Success:
            ServerInterface.sharedInstance.performUserAuthentication(email: emailTextField.text!, password: passwordTextField.text!)
        case let .Failure(message):
            print(message)
        }

    }

    func viewTapped(sender: UITapGestureRecognizer) {
        hideKeyboard()
    }

    func hideKeyboard() {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func registerButtonTapped(sender: AnyObject) {

        if nameTextField.hasText() && emailTextField.hasText() && phoneTextField.hasText() && passwordTextField.hasText() {
            let user = User(id: nil, name: nameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!, reputation: nil, maximumItemsAmount: nil)


            LocationController.sharedInstance.requestUserLocationAndExecute { (coordinate) in
                ServerInterface.sharedInstance.performUserRegistration(user, coordinate: coordinate)
            }
        } else {
            feedbackLabel.text = "Please fill the entire form."
            feedbackLabel.alpha = 0
            feedbackLabel.hidden = false
            UIView.animateWithDuration(0.5, animations: {
                self.feedbackLabel.alpha = 1
            })
        }

    }
    
}
