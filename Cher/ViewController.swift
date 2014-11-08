//
//  ViewController.swift
//  Cher
//
//  Created by Victor Ilyukevich on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import UIKit

typealias Service = (title: String, icon: UIImage, authorized: () -> Bool)

prefix operator |<- {}

prefix func |<- <T>(getter: @autoclosure ()-> T) -> () -> T {
   return getter
}

class ViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var previosSelectedIndexPath: NSIndexPath? = nil
    
    let cells: [Service] = [("Я.Диск", UIImage(named: "ya.disk")!, |<-YandexCredential().isAuthorized),
                            ("Dropbox", UIImage(named: "Dropbox")!, |<-DropboxCredential().isAuthorized)]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = .None

        let service = cells[indexPath.row]
        
        cell.imageView.image                = service.icon
        cell.textLabel.text                 = service.title
        cell.contentView.backgroundColor    = service.authorized() ? UIColor.orangeColor() : UIColor.whiteColor()
        
        if let selected = previosSelectedIndexPath {
            if selected.row == indexPath.row {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let yaDisk = YandexAuthorizator(clientID: "ba2284c5b2534b608daf307387ff3df4")
            yaDisk.requestAuthorization()
        } else if indexPath.row == 1 {
            let dropbox = DropboxAuthorizator(clientID: "bkdb3h4xba8ctxn")
            dropbox.requestAuthorization()

        }
        previosSelectedIndexPath = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }
}
