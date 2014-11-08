//
//  YaSharingService.swift
//  Cher
//
//  Created by Dzianis Lebedzeu on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import Foundation
import UIKit

struct YandexAuthorizator: Authorizator {
    let clientID: String
    
    func requestAuthorization() {
        let url = "https://oauth.yandex.ru/authorize?response_type=token&client_id=\(clientID)&display=popup"
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
}

struct YandexCredential: Credential {
    private func saveCredentials(params: [String: String]) {
        var error: NSErrorPointer = nil
        let success = SSKeychain.setPassword(params["access_token"], forService: "cher", account: "yaDisk", error: error)
        assert(success)
    }
    
    var isAuthorized: Bool {
        return SSKeychain.passwordForService("cher", account: "yaDisk") != nil
    }
    
    func handleOpenURL(url: NSURL) -> Bool {
        if let host = url.host {
            if host != "ya_disk" { return false }
        }
        
        let params = url.fragment!
        
        var result: Dictionary<String, String> = params.componentsSeparatedByString("&").reduce([:], combine: {acc, value in
            let pair = value.componentsSeparatedByString("=")
            if pair.count != 2 {
                return acc
            }
            var result = acc
            result.updateValue(pair.last!, forKey: pair.first!)
            return result
        })
        saveCredentials(result)
        return true
    }
}

