//
//  UserRegistrationViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class UserRegistrationViewController: UIViewController, UserRegistrationObserver {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var mainStoryboard: UIStoryboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        if nameTextField.hasText() && emailTextField.hasText() && phoneTextField.hasText() && passwordTextField.hasText() {
            ServerInterface.sharedInstance.performUserRegistration(User(id: nil, name: nameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!, reputation: nil, maximumItemsAmount: nil))
        } else {
            print("All fields are required")
        }
    }

}
