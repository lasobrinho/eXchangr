//
//  UserRegistrationViewController.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class UserRegistrationViewController: UIViewController, UserRegistrationObserver {

    override func viewDidLoad() {
        super.viewDidLoad()
        ServerInterface.sharedInstance.addUserRegistrationObserver(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ServerInterface.sharedInstance.performUserRegistration(User(id: nil, name: "Igor", email: "igor_martire@gmail.com", password: "igor", reputation: nil, maximumItemsAmount: nil))
    }

    func update(result: UserRegistrationResult) {
        print(result)
        ServerInterface.sharedInstance.removeUserRegistrationObserver(self)
    }

}
