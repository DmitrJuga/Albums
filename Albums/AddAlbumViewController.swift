//
//  AddAlbumViewController.swift
//  Albums
//
//  Created by DmitrJuga on 06.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AddAlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var albums = [JSON]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        label1.text = "Загрузка..."
        label2.hidden = true
        indicator.startAnimating()
        // Загрузка списка альбомов с сервера parse.com
        var headers = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders!
        headers["X-Parse-Application-Id"] = "Db5mlRZuLWCYRMw6WlWO4oXAZ0dEC4PbAwuRtjaw"
        headers["X-Parse-REST-API-Key"] = "osTAZ8pQaiLfp0SduwOriGoHy8YYBxt7xges6crP"
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
        Alamofire.request(.GET, "https://api.parse.com/1/classes/Albums/").responseJSON {
            _, _, jsonData, _ in
            let json = JSON(jsonData!)
            self.albums = JSON(jsonData!)["results"].arrayValue
                dispatch_async(dispatch_get_main_queue()) {
                self.label1.text = "Найдено \(self.albums.count) альбомов"
                self.label2.hidden = false
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func btnCancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - TableViewDataSource
    
    // кол-во элементов
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
    // настраиваем ячейку
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let album = albums[indexPath.row]
        cell.textLabel?.text = album["Name"].stringValue
        cell.detailTextLabel?.text = album["Artist"].stringValue
        return cell
    }


    // MARK: - UITableViewDelegate
    
    // сохраняем выбранный альбом в БД
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        AlbumLibrary.sharedInstance.addAlbum(albums[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
