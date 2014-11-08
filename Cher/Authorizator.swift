//
//  Authorizator.swift
//  Cher
//
//  Created by Dzianis Lebedzeu on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import Foundation

public protocol Authorizator {
    var clientID: String { get }
    func requestAuthorization()
}

public protocol Credential {
    var isAuthorized: Bool { get }
    func handleOpenURL(url: NSURL) -> Bool
}