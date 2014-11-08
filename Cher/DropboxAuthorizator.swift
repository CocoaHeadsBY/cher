//
//  DropboxAuthorizator.swift
//  Cher
//
//  Created by Dzianis Lebedzeu on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import Foundation
import UIKit

struct DropboxAuthorizator: Authorizator {
    let clientID: String
    
    func requestAuthorization() {
        let url = "https://www.dropbox.com/1/oauth2/authorize?client_id=\(clientID)&response_type=token&redirect_uri=cher://dropbox"
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
}

struct DropboxCredential: Credential {
    
    var isAuthorized: Bool {
        return SSKeychain.passwordForService("cher", account: "dropbox") != nil
    }
    
    func handleOpenURL(url: NSURL) -> Bool {
        if let host = url.host {
            if host != "dropbox" { return false }
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
    
    private func saveCredentials(params: [String: String]) {
        var error: NSErrorPointer = nil
        let success = SSKeychain.setPassword(params["access_token"], forService: "cher", account: "dropbox", error: error)
        assert(success)
    }
}