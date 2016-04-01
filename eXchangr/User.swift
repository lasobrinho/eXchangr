//
//  User.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 3/31/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

class User {
    var name: String
    var email: String
    var password: String
    var reputation: Double!
    var maximumItemsAmount: Int!

    init(name: String, email: String, password: String, reputation: Double?, maximumItemsAmount: Int?) {
        self.name = name
        self.email = email
        self.password = password
        self.reputation = reputation
        self.maximumItemsAmount = maximumItemsAmount
    }
}