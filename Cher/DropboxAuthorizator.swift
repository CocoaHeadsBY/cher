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
        return FDKeychain.itemForKey("dropbox", forService: "cher", inAccessGroup: CherKeychainGroup, error: nil) != nil
    }
    
    func handleOpenURL(url: NSURL) -> Bool {
        if let host = url.host {
            if host != "dropbox" { return false }
        }
        
        let params = url.fragment!
        
        saveCredentials(params.queryToParams())
        return true
    }
    
    private func saveCredentials(params: [String: String]) {
        var error: NSErrorPointer = nil
        let success = FDKeychain.saveItem(params["access_token"], forKey: "dropbox", forService: "cher", inAccessGroup: CherKeychainGroup, withAccessibility: FDKeychainAccessibility.AccessibleWhenUnlocked, error: nil)
        assert(success)
    }
}
