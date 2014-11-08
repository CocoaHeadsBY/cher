//
//  ShareViewController.swift
//  CherExtention
//
//  Created by Victor Ilyukevich on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import UIKit
import MobileCoreServices

class ShareViewController: UIViewController {

    func finish() {
        self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }

    // MARK: NSExtensionRequestHandling

    override func beginRequestWithExtensionContext(context: NSExtensionContext) {
        //for testing
        println(FDKeychain.itemForKey("dropbox", forService: "cher", inAccessGroup: "by.cocoaheads.Cher", error: nil))

        super.beginRequestWithExtensionContext(context)

        for item: AnyObject in context.inputItems {
            let inputItem = item as NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeImage as NSString) {
                    itemProvider.loadItemForTypeIdentifier(kUTTypeImage as NSString, options: nil, completionHandler: { (image, error) in
                        if image != nil {
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                println(image as? NSURL)

                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                                    self.finish()
                                })
                            }
                        }
                    })

                    break
                }
            }
        }
    }
}
