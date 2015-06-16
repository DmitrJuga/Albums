//
//  AlbumServer.swift
//  Albums
//
//  Created by DmitrJuga on 15.06.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


/** Класс для работы с удалённым сервером альбомов (на parse.com) */


// MARK: - Album Server Class

class AlbumServer {
    
    /** singleton */
    static let sharedServer = AlbumServer()

    
// MARK: remote server access parameters
    
    // параметры доступа
    private static let appURL = "https://api.parse.com/1/classes/"
    private static let appID = "Db5mlRZuLWCYRMw6WlWO4oXAZ0dEC4PbAwuRtjaw"
    private static let restAPIKey = "osTAZ8pQaiLfp0SduwOriGoHy8YYBxt7xges6crP"
    
    // экземпляр Alamofire.Manager с добавлением ключей доступа в HTTP заголовки
    private let HTTPManager: Alamofire.Manager = {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var headers = Manager.defaultHTTPHeaders
        headers["X-Parse-Application-Id"] = AlbumServer.appID
        headers["X-Parse-REST-API-Key"] = AlbumServer.restAPIKey
        configuration.HTTPAdditionalHeaders = headers
        return Alamofire.Manager(configuration: configuration)
    }()

    
// MARK: remote server requests
    
    private var activeRequests = Array<Alamofire.Request>()
    
    // получение списка альбомов с сервера
    func loadAlbumList(completitionHandler: (jsonAlbums: [JSON]?) -> ()) {
        let params = ["order":"Artist,Name"]
        let request = HTTPManager.request(.GET, AlbumServer.appURL + "Album", parameters: params).responseJSON {
            (_, _, jsonData, _) in
            var result: [JSON]?
            if let jsonData: AnyObject = jsonData {
                result = JSON(jsonData)["results"].array
            }
            completitionHandler(jsonAlbums: result)
        }
        activeRequests.append(request)
    }

    // получение списка альбомов с сервера
    func loadTracksForAlbum(album: JSON, completitionHandler: (jsonTracks: [JSON]?) -> ()) {
        let params = ["where":["$relatedTo":["object":["__type":"Pointer",
                                                    "className":"Album",
                                                     "objectId":album["objectId"].stringValue],
                                                "key":"Tracks"]]]
        let request = HTTPManager.request(.GET, AlbumServer.appURL + "Track", parameters: params).responseJSON {
            (_, _, jsonData, error) in
            var result: [JSON]?
            if let jsonData: AnyObject = jsonData {
                result = JSON(jsonData)["results"].array
            }
            completitionHandler(jsonTracks: result)
        }
        activeRequests.append(request)
    }

    // загрузка картинки с сервера
    func loadImageForAlbum(album: JSON, completitionHandler: (image: UIImage?) -> ()) {
        let request = Alamofire.request(.GET, album["CoverImage"].stringValue).response { (_, _, data, error) in
            var result: UIImage?
            if let data = data as? NSData {
                result = UIImage(data: data)
            }
            completitionHandler(image: result)
        }
        activeRequests.append(request)
    }
    
    // отмена всех активных запросов
    func cancelAllRequests() {
        for request in activeRequests {
            request.cancel()
        }
        activeRequests.removeAll(keepCapacity: true)
    }
}