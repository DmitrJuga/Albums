//
//  AlbumLibrary.swift
//  Albums
//
//  Created by DmitrJuga on 30.03.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


// MARK: - Track
// Структура данных для трека
class Track : NSManagedObject {
    
    @NSManaged var trackNo: Int
    @NSManaged var name: String
    @NSManaged var duration: Int //длительность трека в секундах
    
    //длительность трека в формате "mi:ss"
    var formatedDurarion: String {
        let mi = duration / 60
        let ss = (duration % 60)
        return "\(mi):" + ((ss < 10) ? "0\(ss)" : "\(ss)")
    }
}


// MARK: - Album
// Структура данных для альбома
class Album : NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var artist: String
    @NSManaged var year: Int
    @NSManaged var coverImage: String
    @NSManaged var tracks_: NSSet
    
    // список треков в виде удобного массива вместо NSSet
    var tracks: [Track] {
        get {
            return tracks_.allObjects as! [Track]
        }
        set {
            tracks_ = NSSet(array: newValue)
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


// MARK: - AlbumLibrary
// "Библиотека альбомов"
class AlbumLibrary {

    private static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    private static let albumEntity = NSEntityDescription.entityForName("Album", inManagedObjectContext: context)!
    private static let trackEntity = NSEntityDescription.entityForName("Track", inManagedObjectContext: context)!
    private static var _albums = [Album]()
    
    // кол-во альбомов
    class var count: Int {
        return _albums.count
    }
    
    // альбом по номеру элемента
    class func getAlbum(i: Int) -> Album {
        return self._albums[i]
    }
   
    // начальная загрузка альбомов из БД
    class func loadAlbumsFromDB() {
        var err:NSError?
        let albumsRequest = NSFetchRequest(entityName: "Album")
        let albumsResult = context.executeFetchRequest(albumsRequest, error: &err) as! [Album]?
        if let albums = albumsResult {
            _albums = albums
        } else {
            println("FETCH ERROR \(err)")
        }
    }
    
    // добавляем альбом в БД из json-формата
    class func addAlbum(jsonAlbum: JSON) {
        let album = Album(entity: self.albumEntity, insertIntoManagedObjectContext: context)
        album.name = jsonAlbum["Name"].stringValue
        album.artist = jsonAlbum["Artist"].stringValue
        album.year = jsonAlbum["Year"].intValue
        album.coverImage = jsonAlbum["CoverImage"].stringValue
        album.tracks = jsonAlbum["Tracks"].arrayValue.map {
            (item: JSON) -> Track in
                let track = Track(entity: self.trackEntity, insertIntoManagedObjectContext: self.context)
                track.trackNo = item["TrackNo"].intValue
                track.name = item["Name"].stringValue
                track.duration = item["Duration"].intValue
                return track
        }
        _albums.append(album)
        saveContext()
    }

    // удаление альбома по номеру элемента
    class func deleteAlbum(i: Int) {
        context.deleteObject(_albums.removeAtIndex(i));
        saveContext()
    }
    
    // сохраняемся
    private class func saveContext() {
        var err: NSError?
        if !context.save(&err) {
            println("SAVE ERROR \(err)")
        }
    }

    
}