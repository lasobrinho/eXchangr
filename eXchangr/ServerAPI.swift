//
//  ServerAPI.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 3/31/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

struct ServerAPI {

    static let serverURL = NSURL(string: "http://localhost:3000")!

    static func parseUserRegistrationResponse(data: [AnyObject]) -> UserRegistrationResult {

        let serverResponse = parseServerResponseData(data)
        let responseCode = extractResponseCodeFrom(serverResponse: serverResponse)

        if responseCode == 0 {
            let userJSON = extractUserFrom(serverResponse: serverResponse)
            let user = userFrom(userJSON: userJSON)
            return .Success(user)
        } else {
            let message = extractMessageFrom(serverResponse: serverResponse)
            return .Failure(message)
        }

    }

    static func parseUserAuthenticationResponse(data: [AnyObject]) -> UserAuthenticationResult {

        let serverResponse = parseServerResponseData(data)
        let responseCode = extractResponseCodeFrom(serverResponse: serverResponse)

        if responseCode == 0 {
            let userJSON = extractUserFrom(serverResponse: serverResponse)
            let user = userFrom(userJSON: userJSON)
            return .Success(user)
        } else {
            let message = extractMessageFrom(serverResponse: serverResponse)
            return .Failure(message)
        }
        
    }

    static func createUserRegistrationData(user: User) -> [String : AnyObject]{
        var data = [String : AnyObject]()
        data["user"] = dictionaryFrom(user: user)
        return data
    }

    static func createUserAuthenticationData(email email: String, password: String) -> [String : AnyObject] {
        var data = [String : AnyObject]()
        data["credentials"] = dictionaryFrom(credentials: (email, password))
        return data
    }

    private static func parseServerResponseData(data: [AnyObject]) -> [String : AnyObject] {
        return data[0] as! [String : AnyObject]
    }

    private static func extractResponseCodeFrom(serverResponse serverResponse: [String : AnyObject]) -> Int {
        return serverResponse["responseCode"] as! Int
    }

    private static func extractUserFrom(serverResponse serverResponse: [String : AnyObject]) -> [String : AnyObject] {
        return serverResponse["user"] as! [String : AnyObject]
    }

    private static func extractMessageFrom(serverResponse serverResponse: [String : AnyObject]) -> String {
        return serverResponse["message"] as! String
    }

    private static func userFrom(userJSON userJSON: [String : AnyObject]) -> User {
        guard let id = userJSON["id"] as? Int,
            let name = userJSON["name"] as? String,
            let email = userJSON["email"] as? String,
            let password = userJSON["password"] as? String,
            let reputation = userJSON["reputation"] as? Double,
            let maximumItemsAmount = userJSON["maximumItemsAmount"] as? Int else {
                fatalError()
        }

        return User(id: id, name: name, email: email, password: password, reputation: reputation, maximumItemsAmount: maximumItemsAmount)
    }

    private static func dictionaryFrom(user user: User) -> [String : AnyObject] {
        var dict = [String : AnyObject]()

        dict["name"] = user.name
        dict["email"] = user.email
        dict["password"] = user.password

        if user.id != nil {
            dict["id"] = user.id
        }
        if user.maximumItemsAmount != nil {
            dict["maximumItemsAmount"] = user.maximumItemsAmount
        }
        if user.reputation != nil {
            dict["reputation"] = user.reputation
        }
        
        return dict
    }

    private static func dictionaryFrom(credentials credentials: (email: String, password: String)) -> [String : AnyObject] {
        var dict = [String : AnyObject]()

        dict["email"] = credentials.email
        dict["password"] = credentials.password
        
        return dict
    }
    
}