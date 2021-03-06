//
//  UserAuthenticationResult.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 4/1/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

enum UserAuthenticationResult {
    case Success(User)
    case Failure(String)
}