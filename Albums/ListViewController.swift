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
        return AlbumLibrary.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        // настраиваем ячейку
        cell.populate(AlbumLibrary.list[indexPath.row])
        return cell
    }

    
    // MARK: - Navigation
   
    // настраиваем ImageViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let newVC = segue.destinationViewController as? ImageViewController {
            if let index = self.listTableView.indexPathForSelectedRow()?.row {
                newVC.imageName = AlbumLibrary.list[index].coverImage
            }
        }
    }


}
