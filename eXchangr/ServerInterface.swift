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
        socket.once(ServerResponseEvent.userRegistrationResponse) {
            (data, ack) in
            let registrationResult = ServerAPI.parseUserRegistrationResponse(data)
            callback(result: registrationResult)
        }
    }

    func registerCallbackForUserAuthentication(callback: (result: UserAuthenticationResult) -> ()) {
        socket.once(ServerResponseEvent.userAuthenticationResponse) {
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