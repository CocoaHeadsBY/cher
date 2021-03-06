//
//  ShareViewController.swift
//  CherExtention
//
//  Created by Victor Ilyukevich on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import UIKit
import MobileCoreServices

class Box<T> {
    var val : T
    init(v : T) {
        val = v
    }
}

enum Result<T, E> {
    case Success(Box<T>)
    case Failure(Box<E>)
    func process<U>(s: T -> U, f: E -> U) -> U {
        switch (self) {
        case let .Success(val):
            return s(val.val)
        case let .Failure(err):
            return f(err.val)
        }
    }
    static func success(val: T) -> Result<T, E> {
        return .Success(Box(v: val))
    }
    static func faliture(err: E) -> Result<T, E> {
        return .Failure(Box(v: err))
    }

    static func createResult(val: T, _ err: E!) ->Result<T, E> {
        if err == nil {
            return self<T, E>.success(val)
        }
        else {
            return self<T, E>.faliture(err)
        }
    }
    func map<U>(f: (T) -> U) -> Result<U, E> {
        switch (self) {
            case let .Success(val):
                return Result<U, E>.success(f(val.val))
            case let .Failure(err):
                return Result<U, E>.faliture(err.val)
        }
    }
}

class ShareViewController: UIViewController {

    lazy var uploader: Uploader = {
        let yandexToken = FDKeychain.itemForKey("dropbox", forService: "cher", inAccessGroup: "by.cocoaheads.Cher", error: nil) as? String
        return YandexDiskUploader(token: "23cef53ca7e64384a16c7eacae2efe13") // XXX
        // return YandexDiskUploader(token: yandexToken)
        }()

    let s = { (r: NSURL) -> () in
        // TODO: put the url into copy-paste buffer
        // update status label
        // call the line below
        //self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }

    let f = { (e: NSError) -> () in
        print("Error:")
    }

    func finish(result: Result<NSURL, NSError>) {
        result.process(s, f)
    }

    // MARK: NSExtensionRequestHandling

    override func beginRequestWithExtensionContext(context: NSExtensionContext) {
        super.beginRequestWithExtensionContext(context)
        let kImageType : NSString = kUTTypeImage as NSString;

        for inputItem: NSExtensionItem in context.inputItems as [NSExtensionItem] {
            for itemProvider: NSItemProvider in inputItem.attachments! as [NSItemProvider] {
                if itemProvider.hasItemConformingToTypeIdentifier(kImageType) {
                    itemProvider.loadItemForTypeIdentifier(kImageType, options: nil) { (image, error) in
                        self.uploader.uploadFile(image as NSURL, completionHandler: { (result) -> () in
                            self.finish(Result.createResult(image, error).map { $0 as NSURL })
                        })
                    }
                }
            }
        }
    }
}
