//
//  TracksViewController.swift
//  Albums
//
//  Created by DmitrJuga on 02.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit

class TracksViewController: UIViewController, UITableViewDataSource {
    
    var currentAlbum: Album!
    private var tracks = [Track]()
    
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
        albumCover.image = UIImage(named: currentAlbum.coverImage)
        albumName.text = currentAlbum.name
        artistName.text = currentAlbum.artist
        albumYear.text = String(currentAlbum.year)
        tracksInfo.text = currentAlbum.tracksSummary
        
        // сортировка троков по номеру трека -> в отдельный массив
        tracks = currentAlbum.tracks.sorted{ $0.trackNo < $1.trackNo }
    }
        
    
    // MARK: - TableViewDataSource
    
    // кол-во элементов
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    // настраиваем ячейку
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as! TrackCell
        
        cell.populate(tracks[indexPath.row])
        return cell
    }


}
