//
//  AbstractHandler.swift
//  PerfectTemplate
//
//  Created by Artem Kufaev on 27/04/2019.
//

import PerfectHTTP

protocol AbstractHandler {
    var request: HTTPRequest { get set }
    var response: HTTPResponse { get set }
    func process()
    init(request: HTTPRequest, response: HTTPResponse)
}

extension AbstractHandler {
    func process() { }
}
