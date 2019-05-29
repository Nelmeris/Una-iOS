//
//  YLService.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 28/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Alamofire

class YLService: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: SessionManager
    let queue: DispatchQueue?
    let baseUrl = URL(string: "http://172.20.10.2:8181/")! 
    
    static let shared = YLService()
    
    private init() {
        let factory = YLRequestFactory()
        self.errorParser = factory.makeErrorParser()
        self.sessionManager = factory.commonSessionManager
        self.queue = factory.sessionQueue
    }
}

func getWiFiAddress() -> String? {
    var address : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        
        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
            
            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if  name == "en0" {
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)
    
    return address
}
