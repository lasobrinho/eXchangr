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

    private var authenticatedUser: User?

    init() {
        socket = SocketIOClient(socketURL: ServerAPI.serverURL)
        userAuthenticationObservers = [UserAuthenticationObserver]()
        userRegistrationObservers = [UserRegistrationObserver]()
        registerCallbacks()
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func addAuthenticationObserver(observer: UserAuthenticationObserver) {
        userAuthenticationObservers.append(observer)
    }

    func addUserRegistrationObserver(observer: UserRegistrationObserver) {
        userRegistrationObservers.append(observer)
    }

    private func registerCallbacks() {
        registerCallbackForUserAuthentication()
        registerCallbackForUserAuthentication()
    }

    private func registerCallbackForUserRegistration() {
        socket.once(ServerResponseEvent.userRegistrationResponse) {
            [weak self] (data, ack) in
            let registrationResult = ServerAPI.parseUserRegistrationResponse(data)
            self?.notifyUserRegistrationObservers(registrationResult)
        }
    }

    private func registerCallbackForUserAuthentication() {
        socket.once(ServerResponseEvent.userAuthenticationResponse) {
            [weak self] (data, ack)  in
            let authenticationResult = ServerAPI.parseUserAuthenticationResponse(data)
            self?.notifyUserAuthenticationObservers(authenticationResult)
        }
    }

    private func notifyUserAuthenticationObservers(result: UserAuthenticationResult) {
        for observer in userAuthenticationObservers {
            observer.notify(result)
        }
    }

    private func notifyUserRegistrationObservers(result: UserRegistrationResult) {
        for observer in userRegistrationObservers {
            observer.notify(result)
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