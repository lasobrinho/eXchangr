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
        ServerInterface.sharedInstance.addUserAuthenticationObserver(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ServerInterface.sharedInstance.performUserAuthentication(email: "lucas@gmail.com", password: "password")
    }
    
    func update(result: UserAuthenticationResult) {
        switch result {
        case .Success:
            navigationController?.pushViewController(BrowserViewController(), animated: true)
            ServerInterface.sharedInstance.removeUserAuthenticationObserver(self)
        case let .Failure(message):
            print(message)
        }
    }

}
