//
//  AlbumLibrary.swift
//  Albums
//
//  Created by DmitrJuga on 30.03.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import Foundation
import SwiftyJSON


// Структура данных для трека
struct Track {
    let trackNo: Int
    let name: String
    let duration: Int //длительность трека в секундах
    
    //длительность трека в формате "mi:ss"
    var formatedDurarion: String {
        let mi = duration / 60
        let ss = (duration % 60)
        return "\(mi):" + ((ss < 10) ? "0\(ss)" : "\(ss)")
    }
}


// Структура данных для альбома
struct Album {
    let name: String
    let artist: String
    let year: Int
    let coverImage: String
    let tracks: [Track]
    
    //суммарная дительность всех треков в секундах
    var totalDuration: Int {
        return tracks.reduce(0) {$0 + $1.duration}
    }
    //общая информация о треках
    var tracksSummary: String {
        return "Песен: \(tracks.count); \(totalDuration / 60) мин."
    }
}


// "Библиотека альбомов"
class AlbumLibrary {

    
    private static var _albums: [Album]!
    
    //кол-во альбомов
    class var count: Int {
        return _albums == nil ? 0 : _albums.count
    }
    
    //альбом по номеру элемента
    class func getAlbum(i: Int) -> Album {
        if _albums != nil {
            if (i >= 0) && (i<_albums.count) {
                return self._albums[i]
            }
        }
        //если библиотека пуста или индекс вне диапазона - возвращаем "пустой" альбом
        return Album(name: "#Пустой альбом!", artist: "", year: 1900, coverImage: "coverImg0", tracks:[])
    }
    
    // Загрузка и парсинг json файла
    class func loadFromJSONfile(fileName: String) {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data)
                //корневой объект json массив Albums
                let jsonAlbums = json["Albums"].arrayValue
                //преобразуем в массив [Album] c помощью функции map
                _albums = jsonAlbums.map {
                    Album(
                        name: $0["Name"].stringValue,
                        artist: $0["Artist"].stringValue,
                        year: $0["Year"].intValue,
                        coverImage: $0["CoverImage"].stringValue,
                        tracks: $0["Tracks"].arrayValue.map { //также и с вложенным массивом треков
                            Track(
                                trackNo: $0["TrackNo"].intValue,
                                name: $0["Name"].stringValue,
                                duration: $0["Duration"].intValue
                            )
                        }
                    )
                }
            }

        }
        
    }
    
}