//
//  AddAlbumViewController.swift
//  Albums
//
//  Created by DmitrJuga on 06.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddAlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var jsonAlbums = [JSON]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let server = AlbumServer()
    private let library = AlbumLibrary.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadAlbumList()
    }
    
    // загрузка списка альбомов с сервера
    func loadAlbumList() {
        label1.text = "Загрузка списка..."
        label2.hidden = true
        indicator.startAnimating()
        self.server.loadAlbumList { jsonAlbums in
            dispatch_async(dispatch_get_main_queue()) {
                self.indicator.stopAnimating()
                if let jsonAlbums = jsonAlbums {
                    self.jsonAlbums = jsonAlbums
                    self.label1.text = "Найдено \(self.jsonAlbums.count) альбомов"
                    self.label2.hidden = false
                    self.tableView.reloadData()
                } else {
                    self.label1.textColor = UIColor.redColor()
                    self.label1.text = "Ошибка загрузки с сервера!"
                }
            }
        }
    }
    
    // загрузка выбраного альбома (треки, картинка) с сохранением в библиотеке
    func loadAlbumAndSave(album: JSON, completitionHandler: (success: Bool) -> ()) {
        self.server.loadTracksForAlbum(album, completitionHandler: { jsonTracks in
            if let tracks = jsonTracks {
                self.server.loadImageForAlbum(album, completitionHandler: { image in
                    self.library.addAlbumFromJSON(album, tracks: tracks, image: image)
                    completitionHandler(success: true)
                })
            } else {
                completitionHandler(success: false)
            }
        })
     }
    
    
// MARK: - TableViewDataSource
    
    // кол-во элементов
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonAlbums.count
    }
    
    // настраиваем ячейку
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ServerCell", forIndexPath: indexPath) as! UITableViewCell
        let album = jsonAlbums[indexPath.row]
        cell.textLabel?.text = album["Name"].stringValue
        cell.detailTextLabel?.text = album["Artist"].stringValue
        return cell
    }


// MARK: - UITableViewDelegate
    
    // нажатие на строку - загружаем и сохраняем выбранный альбом в БД
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !indicator.isAnimating() {
            self.label1.textColor = UIColor.blackColor()
            label1.text = "Загрузка альбома..."
            label2.hidden = true
            indicator.startAnimating()
            
            loadAlbumAndSave(jsonAlbums[indexPath.row], completitionHandler: { success in
                dispatch_async(dispatch_get_main_queue(), {
                    self.indicator.stopAnimating()
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.label1.textColor = UIColor.redColor()
                        self.label1.text = "Ошибка загрузки с сервера!"
                        self.label2.hidden = false
                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    }
                })
            })
        }
        
    }
    

// MARK: - Action Handlers
    
    @IBAction func btnCancelPressed(sender: AnyObject) {
        server.cancelAllRequests()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
