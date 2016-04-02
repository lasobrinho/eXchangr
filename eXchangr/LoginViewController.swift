//
//  LoginViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UserAuthenticationObserver {

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.addAuthenticationObserver(self)

        ServerInterface.sharedInstance.performUserAuthentication(email: "lucas@gmail.com", password: "password")
    }

    func update(result: UserAuthenticationResult) {
        print(result)
    }

}
