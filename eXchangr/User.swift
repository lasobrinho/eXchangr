//
//  User.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 3/31/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

class User {

    var id: Int!
    var name: String
    var email: String
    var reputation: Double!
    var maximumItemsAmount: Int!

    init(id: Int?, name: String, email: String, reputation: Double?, maximumItemsAmount: Int?) {
        self.id = id
        self.name = name
        self.email = email
        self.reputation = reputation
        self.maximumItemsAmount = maximumItemsAmount
    }
}