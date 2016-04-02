//
//  ServerAPI.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 3/31/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import UIKit

struct ServerAPI {

    static let serverURL = NSURL(string: "http://localhost:3000")!

    // MARK: User Registration

    static func createUserRegistrationData(user: User) -> [String : AnyObject]{
        var data = [String : AnyObject]()
        data["user"] = dictionaryFrom(user: user)
        return data
    }

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

    //MARK: User Authentication

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

    static func createUserAuthenticationData(email email: String, password: String) -> [String : AnyObject] {
        var data = [String : AnyObject]()
        data["credentials"] = dictionaryFrom(credentials: (email, password))
        return data
    }

    private static func dictionaryFrom(credentials credentials: (email: String, password: String)) -> [String : AnyObject] {
        var dict = [String : AnyObject]()

        dict["email"] = credentials.email
        dict["password"] = credentials.password

        return dict
    }

    //MARK: User

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

    private static func extractUserFrom(serverResponse serverResponse: [String : AnyObject]) -> [String : AnyObject] {
        return serverResponse["user"] as! [String : AnyObject]
    }

    //MARK: Item

    static func createItemAdditionData(item: Item, user: User) -> [String : AnyObject]{
        var data = [String : AnyObject]()
        data["item"] = dictionaryFrom(item: item)
        data["user"] = dictionaryFrom(user: user)
        return data
    }

    static func parseItemAdditionResponse(data: [AnyObject]) -> ItemAdditionResult {

        let serverResponse = parseServerResponseData(data)
        let responseCode = extractResponseCodeFrom(serverResponse: serverResponse)

        if responseCode == 0 {
            let itemJSON = extractItemFrom(serverResponse: serverResponse)
            let item = itemFrom(itemJSON: itemJSON)
            return .Success(item)
        } else {
            let message = extractMessageFrom(serverResponse: serverResponse)
            return .Failure(message)
        }
    }

    private static func extractItemFrom(serverResponse serverResponse: [String : AnyObject]) -> [String : AnyObject] {
        return serverResponse["item"] as! [String : AnyObject]
    }


    private static func dictionaryFrom(item item: Item) -> [String : AnyObject] {
        var dict = [String : AnyObject]()

        dict["name"] = item.name
        dict["description"] = item.description
        dict["active"] = item.active

        return dict
    }

    private static func itemFrom(itemJSON itemJSON: [String : AnyObject]) -> Item {
        guard let id = itemJSON["id"] as? Int,
            let name = itemJSON["name"] as? String,
            let description = itemJSON["description"] as? String,
            let active = itemJSON["active"] as? Bool else {
                fatalError()
        }

        return Item(id: id, name: name, description: description, active: active, pictures: [UIImage]())
    }

    //MARK: General

    private static func parseServerResponseData(data: [AnyObject]) -> [String : AnyObject] {
        return data[0] as! [String : AnyObject]
    }

    private static func extractResponseCodeFrom(serverResponse serverResponse: [String : AnyObject]) -> Int {
        return serverResponse["responseCode"] as! Int
    }
    
    private static func extractMessageFrom(serverResponse serverResponse: [String : AnyObject]) -> String {
        return serverResponse["message"] as! String
    }
}