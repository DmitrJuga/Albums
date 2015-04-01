//
//  Album.swift
//  Albums
//
//  Created by DmitrJuga on 30.03.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import Foundation

// Структура данных для альбома
struct Album {
    let name: String
    let artist: String
    var coverImage: String
}

// "Библиотека альбомов"
struct AlbumLibrary {
    static let list = [Album(name: "Violator", artist: "Depeche Mode", coverImage: "coverImg1"),
                       Album(name: "Meet the Beatles", artist: "The Beatles", coverImage: "coverImg2"),
                       Album(name: "Yellow Submarine", artist: "The Beatles", coverImage: "coverImg3"),
                       Album(name: "Wind of Change", artist: "Scorpions", coverImage: "coverImg4"),
                       Album(name: "Nothing But The Best", artist: "Frank Sinatra", coverImage: "coverImg5")]
}