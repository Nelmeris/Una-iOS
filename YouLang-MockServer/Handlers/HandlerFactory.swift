//
//  HandlerFactory.swift
//  PerfectTemplate
//
//  Created by Artem Kufaev on 27/04/2019.
//

import PerfectHTTP

class HandlerFactory {
    
    public func handlerFor(request: HTTPRequest, response: HTTPResponse) -> AbstractHandler {
        switch request.path {
        case "/auth.login":
            return LoginHandler(request: request, response: response)
        case "/auth.register":
            return RegisterHandler(request: request, response: response)
        case "/auth.logout":
            return LogoutHandler(request: request, response: response)
        case "/user.getInfo":
            return GetUserInfoHandler(request: request, response: response)
        case "/cources.get":
            return GetCourcesHandler(request: request, response: response)
        default:
            return ErrorHandler(request: request, response: response)
        }
    }
    
}
