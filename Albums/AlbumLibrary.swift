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


// /** Класс для работы с "Библиотекой альбомов" */


// MARK: - Album Library Class

class AlbumLibrary {

    static let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    static let albumEntity = NSEntityDescription.entityForName("Album", inManagedObjectContext: context)!
    static let trackEntity = NSEntityDescription.entityForName("Track", inManagedObjectContext: context)!
    
    var albums = [Album]()
    
    /** singleton */
    static var sharedInstance = AlbumLibrary()
    
    /** constructor */
    private init() {
        
        loadAlbumsFromDB()
    }
   
    // начальная загрузка альбомов из БД
    func loadAlbumsFromDB() {
        
        var err:NSError?
        let request = NSFetchRequest(entityName: "Album")
        let requestResult = AlbumLibrary.context.executeFetchRequest(request, error: &err) as! [Album]?
        if let albumsResult = requestResult {
            albums = albumsResult
        } else {
            println("FETCH ERROR \(err)")
        }
    }
    
    // добавляем альбом в БД из json-формата
    func addAlbum(jsonAlbum: JSON) {
        
        let album = Album(entity: AlbumLibrary.albumEntity, insertIntoManagedObjectContext: AlbumLibrary.context)
        album.name = jsonAlbum["Name"].stringValue
        album.artist = jsonAlbum["Artist"].stringValue
        album.year = jsonAlbum["Year"].intValue
        album.coverImage = jsonAlbum["CoverImage"].stringValue
        album.tracks = jsonAlbum["Tracks"].arrayValue.map {
            (item: JSON) -> Track in
                let track = Track(entity: AlbumLibrary.trackEntity, insertIntoManagedObjectContext: AlbumLibrary.context)
                track.trackNo = item["TrackNo"].intValue
                track.name = item["Name"].stringValue
                track.duration = item["Duration"].intValue
                return track
        }
        albums.append(album)
        saveContext()
    }

    // удаление альбома по номеру элемента
    func deleteAlbum(i: Int) {
        
        AlbumLibrary.context.deleteObject(self.albums.removeAtIndex(i));
        saveContext()
    }
    
    // сохраняемся
    private func saveContext() {
        
        var err: NSError?
        if !AlbumLibrary.context.save(&err) {
            println("SAVE ERROR \(err)")
        }
    }

    
}