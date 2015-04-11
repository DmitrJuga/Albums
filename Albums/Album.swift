//
//  Album.swift
//  Albums
//
//  Created by DmitrJuga on 11.04.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import Foundation
import CoreData


/** Структура данных для альбома */


// MARK: - Album: Core Data Managed Object
class Album: NSManagedObject {

    @NSManaged var artist: String
    @NSManaged var coverImage: String
    @NSManaged var name: String
    @NSManaged var year: NSInteger
    @NSManaged private var trackSet: NSSet

}


// MARK: - Album: extensions
extension Album {

    // список треков в виде удобного массива вместо NSSet
    var tracks: [Track] {
        get {
            return trackSet.allObjects as! [Track]
        }
        set {
            trackSet = NSSet(array: newValue)
        }
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