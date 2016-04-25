//
//  UserRegistrationViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class UserRegistrationViewController: UIViewController, UserRegistrationObserver {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    var mainStoryboard: UIStoryboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.addUserRegistrationObserver(self)
        mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func update(result: UserRegistrationResult) {
        switch result {
        case .Success:
            ServerInterface.sharedInstance.performUserAuthentication(email: emailLabel.text!, password: passwordLabel.text!)
        case let .Failure(message):
            print(message)
        }
        
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        if nameLabel.hasText() && emailLabel.hasText() && phoneLabel.hasText() && passwordLabel.hasText() {
            ServerInterface.sharedInstance.performUserRegistration(User(id: nil, name: nameLabel.text!, email: emailLabel.text!, phone: phoneLabel.text!, password: passwordLabel.text!, reputation: nil, maximumItemsAmount: nil))
        } else {
            print("All fields are required")
        }
    }

}
