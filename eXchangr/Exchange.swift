//
//  Exchange.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/30/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

class Exchange {

    let distance: Double
    let otherUser: User
    let itemsLikedByTheOtherUser: [Item]
    let otherUserItemsThatILike: [Item]

    init(distance: Double, otherUser: User, itemsLikedByTheOtherUser: [Item], otherUserItemsThatILike: [Item]) {
        self.distance = distance
        self.otherUser = otherUser
        self.itemsLikedByTheOtherUser = itemsLikedByTheOtherUser
        self.otherUserItemsThatILike = otherUserItemsThatILike
    }
}