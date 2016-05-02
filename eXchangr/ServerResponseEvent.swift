//
//  ServerResponseEvent.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 3/31/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

struct ServerResponseEvent {

    static let userRegistrationResponse = "userRegistrationResponse"
    static let userAuthenticationResponse = "userAuthenticationResponse"
    static let itemAdditionResponse = "itemAdditionResponse"
    static let itemBrowsingResponse = "itemBrowsingResponse"
    static let itemRemovalResponse = "itemRemovalResponse"
    static let itemRetrievalResponse = "itemRetrievalResponse"
    static let itemDistanceResponse = "itemDistanceResponse"
    static let itemUpdateResponse = "itemUpdateResponse"
    static let reactionResponse = "reactionResponse"
    static let exchangesResponse = "exchangesResponse"
    static let userCoordinateResponse = "userCoordinatesResponse"
    static let updateUserCoordinateResponse = "updateUserCoordinateResponse"
}