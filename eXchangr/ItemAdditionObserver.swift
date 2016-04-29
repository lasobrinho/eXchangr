//
//  ItemAdditionObserver.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/2/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

protocol ItemAdditionObserver: class {
    func update(result: ItemAddOrUpdateResult)
}