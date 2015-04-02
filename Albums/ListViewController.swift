//
//  ListViewController.swift
//  Albums
//
//  Created by DmitrJuga on 30.03.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var listTableView: UITableView!
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // кол-во элементов
        return AlbumLibrary.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        // настраиваем ячейку
        let album = AlbumLibrary.getAlbum(indexPath.row)
        cell.populate(album)
        return cell
    }

    
    // MARK: - Navigation
   
    // настраиваем AlbumDetailsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let newVC = segue.destinationViewController as? AlbumDetailsViewController {
            if let index = self.listTableView.indexPathForSelectedRow()?.row {
                newVC.currentAlbum = AlbumLibrary.getAlbum(index)
            }
        }
    }


}
