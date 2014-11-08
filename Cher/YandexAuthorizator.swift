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

    var isAuthorized: Bool {
        return FDKeychain.itemForKey("yaDisk", forService: "cher", inAccessGroup: CherKeychainGroup, error: nil) != nil
    }
    
    func handleOpenURL(url: NSURL) -> Bool {
        if let host = url.host {
            if host != "ya_disk" { return false }
        }
        
        let params = url.fragment!
        
        saveCredentials(params.queryToParams())
        return true
    }
    
    private func saveCredentials(params: [String: String]) {
        var error: NSErrorPointer = nil
        let success = FDKeychain.saveItem(params["access_token"], forKey: "yaDisk", forService: "cher", inAccessGroup: CherKeychainGroup, withAccessibility: FDKeychainAccessibility.AccessibleWhenUnlocked, error: nil)
        assert(success)
    }
    
}

