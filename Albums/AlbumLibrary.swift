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


let AlbumAddedNotification = "DDAlbumLibraryChangedNotificationWhenAlbumAdded"
let AlbumDeletedNotification = "DDAlbumLibraryChangedNotificationWhenAlbumDeleted"


/** Класс для работы с "Библиотекой альбомов" */


// MARK: - Album Library Class

class AlbumLibrary {
    
    var albums: [Album]
    
    /** singleton */
    static let sharedInstance = AlbumLibrary()
    
    /** constructor */
    private init() {
        // начальная загрузка альбомов из БД
        albums = CoreDataHelper.sharedInstance.fetchObjectsForEntityNamed(Album.entityName) as! [Album]
    }

    // добавляем альбом в БД из json-формата
    func addAlbumFromJSON(album: JSON, tracks: [JSON], image: UIImage?) -> Album {
        let album = Album.createFromJSON(album)
        if let image = image {
            album.coverImage = UIImagePNGRepresentation(image)
        }
        album.tracks = tracks.map { Track.createFromJSON( $0) }
        CoreDataHelper.sharedInstance.save()
        albums.append(album)
        let newIndex = albums.count - 1
        NSNotificationCenter.defaultCenter().postNotificationName(AlbumAddedNotification,
                                                           object: self,
                                                         userInfo: ["index" : newIndex])
        return album
    }

    // удаление альбома по номеру элемента
    func deleteAlbumAtIndex(index: Int) {
        if index >= 0 && index < albums.count {
            CoreDataHelper.sharedInstance.deleteObject(self.albums.removeAtIndex(index));
            CoreDataHelper.sharedInstance.save()
            let newIndex = index == albums.count ? albums.count - 1 : index
            NSNotificationCenter.defaultCenter().postNotificationName(AlbumDeletedNotification,
                                                               object: self,
                                                             userInfo: ["index" : newIndex])
        }
    }
    
}