//
//  UserAuthenticationObserver.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

protocol UserAuthenticationObserver {
    func notify(result: UserAuthenticationResult)
}