//
//  ShareViewController.swift
//  CherExtention
//
//  Created by Victor Ilyukevich on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import UIKit
import MobileCoreServices

enum Result<T> {
    case Success(T)
    case Failure(String)
    func process<U>(s: T -> U, f: String -> U) -> U {
        switch (self) {
        case let .Success(val):
            return s(val)
        case let .Failure(err):
            return f(err)
        }
    }
}

class ShareViewController: UIViewController {
    let s = { (r: String) -> () in

        //self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }

    let f = { (e: String) -> () in
        print("Error:")
    }

    func finish(result: Result<String>) {
        result.process(s, f)

    }

    // MARK: NSExtensionRequestHandling

    override func beginRequestWithExtensionContext(context: NSExtensionContext) {
        super.beginRequestWithExtensionContext(context)

        for item: AnyObject in context.inputItems {
            let inputItem = item as NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as NSString) {
                    itemProvider.loadItemForTypeIdentifier(kUTTypeImage as NSString, options: nil, completionHandler: { (image, error) in
                        return ()
//                        (image as? NSURL).map { (imageURL : NSURL) -> () in
//                            NSOperationQueue.mainQueue().addOperationWithBlock {
//                                println(imageURL)
//                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
//                                    var result = Result.Success(image)
//                                    self.finish()
//                                })
//                            }
//                        }

                    })

                    //break
                }
            }
        }
    }
}
