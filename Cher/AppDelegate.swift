//
//  AppDelegate.swift
//  Cher
//
//  Created by Victor Ilyukevich on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import UIKit

let CherKeychainGroup = "by.cocoaheads.Cher"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return YandexCredential().handleOpenURL(url) || DropboxCredential().handleOpenURL(url)
    }
}

