//
//  Track.swift
//  Albums
//
//  Created by DmitrJuga on 11.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


/** Структура данных для трека */


// MARK: - Track: Core Data Managed Object

class Track: NSManagedObject {

    @NSManaged var duration: NSInteger
    @NSManaged var name: String
    @NSManaged var trackNo: NSInteger
    @NSManaged var fromAlbum: Album
    
    static let entityName = "Track"

}


// MARK: - Track extension

extension Track {
    
    // маппинг полей из JSON объекта
    class func createFromJSON(json: JSON) -> Track {
        let obj = CoreDataHelper.sharedInstance.addObjectForEntityNamed(entityName) as! Track
        obj.trackNo = json["TrackNo"].intValue
        obj.name = json["Name"].stringValue
        obj.duration = json["Duration"].intValue
        return obj
    }
    
    //длительность трека в формате "mi:ss"
    var formatedDurarion: String {
        let mi = duration / 60
        let ss = (duration % 60)
        return "\(mi):" + ((ss < 10) ? "0\(ss)" : "\(ss)")
    }
}