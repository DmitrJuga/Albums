//
//  AlbumsViewController.swift
//  Albums
//
//  Created by DmitrJuga on 30.03.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private let library = AlbumLibrary.sharedInstance
    
    var observer: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        // создаём обработчик нотификаций от AlbumLibrary
        observer = NSNotificationCenter.defaultCenter().addObserverForName(AlbumAddedNotification, object: nil,
                                                                    queue: NSOperationQueue.mainQueue()) { notification  in
            self.tableView.reloadData()
            let row = notification.userInfo!["index"] as! Int
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
    
    // отписываемся от нотификаций
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(observer!)
    }
    
    
// MARK: - TableViewDataSource
    
    // кол-во элементов
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.albums.count
    }
    
    // настраиваем ячейку
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        cell.populate(library.albums[indexPath.row])
        return cell
    }
    
    // разрешаем редактировать
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }

     // удаление записи
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            library.deleteAlbumAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    
// MARK: - Navigation
   
    // настраиваем TracksViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let newVC = segue.destinationViewController as? TracksViewController,
           let index = self.tableView.indexPathForSelectedRow()?.row {
                newVC.album = library.albums[index]
        }
    }

}
