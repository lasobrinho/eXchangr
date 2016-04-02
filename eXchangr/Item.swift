//
//  Item.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class Item {

    var id: Int?
    var name: String
    var description: String
    var active: Bool
    var pictures: [UIImage]

    init(id: Int?, name: String, description: String, active: Bool, pictures: [UIImage]) {
        self.id = id
        self.name = name
        self.description = description
        self.active = active
        self.pictures = pictures
    }
}