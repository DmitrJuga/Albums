//
//  TracksViewController.swift
//  Albums
//
//  Created by DmitrJuga on 02.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit

class TracksViewController: UIViewController, UITableViewDataSource {
    
    var album: Album!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumYear: UILabel!
    @IBOutlet weak var tracksInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        // настройка вида
        albumCover.image = album.image
        albumName.text = album.name
        artistName.text = album.artist
        albumYear.text = String(album.year)
        tracksInfo.text = album.tracksSummary
    }
        
    
// MARK: - TableViewDataSource
    
    // кол-во элементов
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.tracks.count
    }
    
    // настраиваем ячейку
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as! TrackCell
        cell.populate(album.tracks[indexPath.row])
        return cell
    }


}
