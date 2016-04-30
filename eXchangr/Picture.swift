//
//  Picture.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

class Picture {
    var id: Int?
    var bytes: NSData

    init(id: Int?, bytes: NSData) {
        self.id = id
        self.bytes = bytes
    }

    func asUIImage() -> UIImage {
        return UIImage(data: bytes)!
    }
}