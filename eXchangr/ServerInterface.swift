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

    init() {
        socket = SocketIOClient(socketURL: ServerAPI.serverURL)
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func registerCallbackForUserRegistration(callback: (result: UserRegistrationResult) -> ()) {
        removeCallbackForUserRegistration()
        socket.on(ServerResponseEvent.userRegistrationResponse) {
            (data, ack) in
            let registrationResult = ServerAPI.parseUserRegistrationResponse(data)
            callback(result: registrationResult)
        }
    }

    func registerCallbackForUserAuthentication(callback: (result: UserAuthenticationResult) -> ()) {
        removeCallbackForUserAuthentication()
        socket.on(ServerResponseEvent.userAuthenticationResponse) {
            (data, ack) in
            let authenticationResult = ServerAPI.parseUserAuthenticationResponse(data)
            callback(result: authenticationResult)
        }
    }

    func removeCallbackForUserAuthentication() {
        socket.off(ServerResponseEvent.userAuthenticationResponse)
    }

    func removeCallbackForUserRegistration() {
        socket.off(ServerResponseEvent.userRegistrationResponse)
    }

    func performUserRegistration(user: User) {
        if socket.status == .Connected {
            let data = ServerAPI.createUserRegistrationData(user)
            socket.emit(ClientEvent.userRegistration, data)
        }
    }

    func performUserAuthentication(email email: String, password: String) {
        if socket.status == .Connected {
            let data = ServerAPI.createUserAuthenticationData(email: email, password: password)
            socket.emit(ClientEvent.userAuthentication, data)
        }
    }
}