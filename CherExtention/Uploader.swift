//
//  Uploader.swift
//  Cher
//
//  Created by Victor Ilyukevich on 11/9/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import Foundation

protocol Uploader {
    init(token: String)
    func uploadFile(fileUrl: NSURL, completionHandler: (Result<String, NSError>) -> () )
}
