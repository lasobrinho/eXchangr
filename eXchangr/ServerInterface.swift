//
//  ServerInterface.swift
//  eXchangr
//
//  Created by Lucas Barbosa on 3/31/16.
//  Copyright © 2016 eXchangr. All rights reserved.
//

import Foundation

class ServerInterface {
    static let sharedInstance = ServerInterface()

    private let socket: SocketIOClient

    private var userAuthenticationObservers: [UserAuthenticationObserver]
    private var userRegistrationObservers: [UserRegistrationObserver]
    private var itemAdditionObservers: [ItemAdditionObserver]

    private var authenticatedUser: User?

    private init() {
        socket = SocketIOClient(socketURL: ServerAPI.serverURL)

        userAuthenticationObservers = [UserAuthenticationObserver]()
        userRegistrationObservers = [UserRegistrationObserver]()
        itemAdditionObservers = [ItemAdditionObserver]()

        registerCallbacks()
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func addUserAuthenticationObserver(observer: UserAuthenticationObserver) {
        userAuthenticationObservers.append(observer)
    }

    func removeUserAuthenticationObserver(observer: UserAuthenticationObserver) {
        for (index,existingObserver) in userAuthenticationObservers.enumerate() {
            if observer === existingObserver {
                userAuthenticationObservers.removeAtIndex(index)
                break
            }
        }
    }

    func addUserRegistrationObserver(observer: UserRegistrationObserver) {
        userRegistrationObservers.append(observer)
    }

    func removeUserRegistrationObserver(observer: UserRegistrationObserver) {
        for (index,existingObserver) in userRegistrationObservers.enumerate() {
            if observer === existingObserver {
                userRegistrationObservers.removeAtIndex(index)
                break
            }
        }
    }

    func addItemAdditionObserver(observer: ItemAdditionObserver) {
        itemAdditionObservers.append(observer)
    }

    func removeItemAdditionObserver(observer: ItemAdditionObserver) {
        for (index,existingObserver) in itemAdditionObservers.enumerate() {
            if observer === existingObserver {
                itemAdditionObservers.removeAtIndex(index)
                break
            }
        }
    }

    func performUserRegistration(user: User) {
        let data = ServerAPI.createUserRegistrationData(user)
        emitEvent(ClientEvent.userRegistration, data: data)
    }

    func performUserAuthentication(email email: String, password: String) {
        let data = ServerAPI.createUserAuthenticationData(email: email, password: password)
        emitEvent(ClientEvent.userAuthentication,  data: data)
    }

    func performUserLogout() {
        authenticatedUser = nil
    }

    func performItemAddition(item: Item) {
        let data = ServerAPI.createItemAdditionData(item, user: self.authenticatedUser!)
        emitEvent(ClientEvent.itemAddition, data: data)
    }

    func requestElegibleItemsList(callback: (items: [Item]) -> ()) {
        if authenticatedUser != nil {
            socket.once(ServerResponseEvent.itemBrowsingResponse) {
                data, ack in
                callback(items: ServerAPI.parseItemArrayResponse(data))
            }

            emitEvent(ClientEvent.itemBrowsing, data: ServerAPI.createRequestItemsData(authenticatedUser!))
        } else {
            fatalError()
        }
    }

    func fetchAuthenticatedUserItemsList(callback: (items: [Item]) -> ()) {
        if authenticatedUser != nil {
            socket.once(ServerResponseEvent.itemRetrievalResponse) {
                data, ack in
                callback(items: ServerAPI.parseItemArrayResponse(data))
            }

            emitEvent(ClientEvent.itemRetrieval, data: ServerAPI.createRequestItemsData(authenticatedUser!))
        } else {
            fatalError()
        }
    }

    func requestItemRemoval(item: Item, callback: (success: Bool) -> ()) {
        if authenticatedUser != nil {
            socket.once(ServerResponseEvent.itemRemovalResponse) {
                data, ack in
                callback(success: ServerAPI.parseItemRemovalResponse(data))
            }

            emitEvent(ClientEvent.itemRemoval, data: ServerAPI.createSimpleItemRequestData(item, authenticatedUser: authenticatedUser!))
        } else {
            fatalError()
        }
    }

    func requestDistanceForItem(item: Item, callback: (distance: Double) -> ()) {
        if authenticatedUser != nil {
            socket.once(ServerResponseEvent.itemRetrievalResponse) {
                data, ack in
                callback(distance: ServerAPI.parseRequestDistanceForItemResponse(data))
            }

            emitEvent(ClientEvent.itemRetrieval, data: ServerAPI.createSimpleItemRequestData(item, authenticatedUser: authenticatedUser!))
        } else {
            fatalError()
        }

    }

    private func registerCallbacks() {
        registerCallbackForUserRegistration()
        registerCallbackForUserAuthentication()
        registerCallbackForItemAddition()
    }

    private func registerCallbackForUserRegistration() {
        socket.on(ServerResponseEvent.userRegistrationResponse) {
            [weak self] (data, ack) in
            let registrationResult = ServerAPI.parseUserRegistrationResponse(data)
            self?.notifyUserRegistrationObservers(registrationResult)
        }
    }

    private func registerCallbackForUserAuthentication() {
        socket.on(ServerResponseEvent.userAuthenticationResponse) {
            [weak self] (data, ack)  in
            let authenticationResult = ServerAPI.parseUserAuthenticationResponse(data)
            switch authenticationResult {
            case let .Success(user):
                self?.authenticatedUser = user
            default: break
            }
            self?.notifyUserAuthenticationObservers(authenticationResult)
        }
    }

    private func registerCallbackForItemAddition() {
        socket.on(ServerResponseEvent.itemAdditionResponse) {
            [weak self] (data, ack) in
            let additionResult = ServerAPI.parseItemAdditionResponse(data)
            self?.notifyItemAdditionObservers(additionResult)
        }
    }

    private func notifyUserAuthenticationObservers(result: UserAuthenticationResult) {
        for observer in userAuthenticationObservers {
            observer.update(result)
        }
    }

    private func notifyUserRegistrationObservers(result: UserRegistrationResult) {
        for observer in userRegistrationObservers {
            observer.update(result)
        }
    }

    private func notifyItemAdditionObservers(result: ItemAdditionResult) {
        for observer in itemAdditionObservers {
            observer.update(result)
        }
    }

    private func emitEvent(event: String, data: AnyObject) {
        if socket.status == .Connected {
            socket.emit(event, data)
        } else {
            socket.once("connect") {
                _ in
                self.socket.emit(event, data)
            }
        }
    }
    
}