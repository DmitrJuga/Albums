//
//  TrackCell.swift
//  Albums
//
//  Created by DmitrJuga on 02.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    @IBOutlet weak var trackNo: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    
    //Настройка ячейки в списке треков
    func populate(track: Track){
        trackNo.text = String(track.trackNo)
        trackName.text = track.name
        trackDuration.text = track.formatedDurarion
    }

}
