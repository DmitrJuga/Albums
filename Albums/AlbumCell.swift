//
//  AlbubCell.swift
//  Albums
//
//  Created by DmitrJuga on 30.03.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var tracksInfo: UILabel!
    
    //Настройка ячейки в списке альбомов
    func populate(album: Album){
        
        albumCover.image = UIImage(named: album.coverImage)
        albumName.text = album.name
        artistName.text = album.artist
        tracksInfo.text = album.tracksSummary
    }

}
