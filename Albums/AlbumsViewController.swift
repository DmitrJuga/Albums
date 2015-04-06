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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // кол-во элементов
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlbumLibrary.count
    }
    
    // настраиваем ячейку
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        
        let album = AlbumLibrary.getAlbum(indexPath.row)
        cell.populate(album)
        return cell
    }
    
    // разрешаем редактировать
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }

    
    // удаление записи
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            AlbumLibrary.deleteAlbum(indexPath.row)
            tableView.reloadData()
        }
    }

    
    // MARK: - Navigation
   
    // настраиваем TracksViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let newVC = segue.destinationViewController as? TracksViewController {
            if let index = self.tableView.indexPathForSelectedRow()?.row {
                newVC.currentAlbum = AlbumLibrary.getAlbum(index)
            }
        }
    }


}
