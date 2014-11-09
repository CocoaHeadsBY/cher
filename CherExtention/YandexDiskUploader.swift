//
//  YandexDiskUploader.swift
//  Cher
//
//  Created by Victor Ilyukevich on 11/9/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import Foundation

class YandexDiskUploader : NSObject, Uploader, NSURLSessionDelegate {
    var session: NSURLSession
    var token: String

    // MARK - Uploader

    required init(token: String) {
        self.token = token
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
        super.init()
    }

    func uploadFile(fileUrl: NSURL, completionHandler: (Result<String, NSError>) -> ()) {
        // TODO
        // 1. request upload url and method (Source: http://api.yandex.com/disk/api/reference/upload.xml )
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

        let fileName = self.uniqueFilenameForFileAtURL(fileUrl)
        let url = NSURL(string: "https://cloud-api.yandex.net/v1/disk/resources/upload?path=\(fileName)")
        var request = NSMutableURLRequest(URL: url!)
        request.setValue("OAuth \(self.token)", forHTTPHeaderField: "Authorization")
        let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            // TODO: handle error
            var s: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            println(s.objectForKey("message")) // right now we are getting error. Probaby there is something wrong with permissions
        })

        task.resume()

        // 2. Upload to the URL we got from step 1. Method PUT.
        // No OAuth headers

        // 3. Make file public and get the link to it. (Source: http://api.yandex.com/disk/api/reference/publish.xml#publish-q )
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

    private

    func uniqueFilenameForFileAtURL(url: NSURL) -> String {
        var ext: String = url.pathExtension
        if ext.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            ext = ".\(ext)" // we want to append extension only if it exists
        }

        return "\(NSProcessInfo.processInfo().globallyUniqueString)\(ext)"
    }
}
