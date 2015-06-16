//
//  Album.swift
//  Albums
//
//  Created by DmitrJuga on 11.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


/** Структура данных для альбома */


// MARK: - Album: Core Data Managed Object

class Album: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var artist: String
    @NSManaged var coverImage: NSData
    @NSManaged var coverURL: String
    @NSManaged var year: NSInteger
    @NSManaged private var trackSet: NSOrderedSet

    static let entityName = "Album"

}


// MARK: - Album extension

extension Album {

    // маппинг полей из JSON объекта
    class func createFromJSON(json: JSON) -> Album {
        var obj = CoreDataHelper.sharedInstance.addObjectForEntityNamed(entityName) as! Album
        obj.name = json["Name"].stringValue
        obj.artist = json["Artist"].stringValue
        obj.year = json["Year"].intValue
        obj.coverURL = json["CoverImage"].stringValue
        return obj
    }
    
    // список треков в виде удобного массива вместо NSSet
    var tracks: [Track] {
        get {
            return trackSet.array as! [Track]
        }
        set {
            trackSet = NSOrderedSet(array: newValue.sorted{$0.0.trackNo <= $0.1.trackNo})
        }
    }
    
    // обложка альбома в виде UIImage
    var image: UIImage {
        return UIImage(data: coverImage) ?? UIImage(named: "defaultCover")!
    }
    
    // суммарная дительность всех треков в секундах
    var totalDuration: Int {
        return tracks.reduce(0) {$0 + $1.duration}
    }
    // общая информация о треках
    var tracksSummary: String {
        return "Песен: \(tracks.count); \(totalDuration / 60) мин."
    }
    
}