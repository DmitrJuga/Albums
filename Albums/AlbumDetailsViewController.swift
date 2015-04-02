//
//  AlbumDetailsViewController.swift
//  Albums
//
//  Created by DmitrJuga on 02.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController, UITableViewDataSource {
            
    
    var currentAlbum: Album!
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumYear: UILabel!
    @IBOutlet weak var tracksInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCover.image = UIImage(named: currentAlbum.coverImage)
        albumName.text = currentAlbum.name
        artistName.text = currentAlbum.artist
        albumYear.text = String(currentAlbum.year)
        tracksInfo.text = currentAlbum.tracksSummary
    }
        
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // кол-во элементов
        return currentAlbum.tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as! TrackCell
        // настраиваем ячейку
        let track = currentAlbum.tracks[indexPath.row]
        cell.populate(track)
        return cell
    }


}
