//
//  YandexDiskUploader.swift
//  Cher
//
//  Created by Victor Ilyukevich on 11/9/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import Foundation

class YandexDiskUploader : NSObject, Uploader, NSURLSessionDelegate {
    var session: NSURLSession?

    // MARK - Uploader

    required init(credentials aCredentials: String) {
        super.init()
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
    }

    func uploadFile(fileUrl: NSURL, completion: Result<String, NSError>) {
        // TODO
        // 1. request upload url and method (Source: http://api.yandex.com/disk/api/reference/upload.xml)
        // https://cloud-api.yandex.net/v1/disk/resources/upload?path=<path where you want to upload the file>
        // Authorization: OAuth 0c4181a7c2cf4521964a72ff57a34a07
        //
        // NOTE: we are responsible for not overriding a file already exists. Provide unique path
        //
        // Sample response:
        // {
        //   "href": "https://uploader1d.dst.yandex.net:443/upload-target/...",
        //   "method": "PUT",
        //   "templated": false
        // }

        // 2. Upload to the URL we got from step 1. Method PUT.
        // No OAuth headers

        // 3. Make file public and get the link to it. (Source: http://api.yandex.com/disk/api/reference/publish.xml#publish-q)
        // PUT https://cloud-api.yandex.net/v1/disk/resources/publish?path=<path to resource being published>
        // Authorization: OAuth 0c4181a7c2cf4521964a72ff57a34a07
        //
        // Sample response:
        // {
        //   "href": "https://cloud-api.yandex.net/v1/disk/resources?path=disk%3A%2Fbar%2Fphoto.png",
        //   "method": "GET",
        //   "templated": false
        // }

        // Return public link to the file or error from any of the steps described above.
    }
}
