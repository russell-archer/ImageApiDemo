//
//  PixabayData.swift
//  ImageApiDemo
//
//  Created by Russell Archer on 19/06/2018.
//  Copyright © 2018 Russell Archer. All rights reserved.
//

import Foundation

/*

    An example of the structure of the JSON we're loading is as follows:
 
     {
         "totalHits":500,
         "hits":[
             {
                 "largeImageURL":"https://pixabay.com/get/e837b90f2df7063ed1584d05fb1d4292e07ee1d718ac104497f9c57bafefbdb0_1280.jpg",
                 "webformatHeight":425,
                 "webformatWidth":640,
                 "likes":776,
                 "imageWidth":3008,
                 "id":1280537,
                 "user_id":2275370,
                 "views":258127,
                 "comments":86,
                 "pageURL":"https://pixabay.com/en/cup-of-coffee-laptop-office-macbook-conc-1280537/",
                 "imageHeight":2000,
                 "webformatURL":"https://pixabay.com/get/e837b90f2df7063ed1584d05fb1d4292e07ee1d718ac104497f9c57bafefbdb0_640.jpg",
                 "type":"photo",
                 "previewHeight":99,
                 "tags":"",
                 "downloads":137091,
                 "user":"freephotocc",
                 "favorites":972,
                 "imageSize":1386432,
                 "previewWidth":150,
                 "userImageURL":"https://cdn.pixabay.com/user/2017/08/03/10-16-32-389_250x250.png",
                 "previewURL":"https://cdn.pixabay.com/photo/2016/03/26/13/09/organic-1280537_150.jpg"
             },
             {
                 "largeImageURL":"xxx",
                 :
             },
             {
                 "largeImageURL":"yyy",
                 :
             }],
         "total":4815
     }
 
    The Codable, Encodable and Decodable protocols were introduced with in Swift 4 to help with
    serializing/deserializing and parsing JSON data.

    Use the Encodable protocol when you want to encode your own data.
    Use the Decodable protocol when you want to decode data loaded from the network.
    Use the Codable protocol if you want decoding and encoding in the same app
 
 */

public struct PixabayData: Decodable {
    var totalHits: Int
    var hits: [PixabayImage]
    var total: Int
}

public struct PixabayImage: Decodable {
    var largeImageURL: String
    var webformatHeight: Int
    var webformatWidth: Int
    var likes: Int
    var imageWidth: Int
    var id: Int
    var userId: Int
    var views: Int
    var comments: Int
    var pageURL: String
    var imageHeight: Int
    var webformatURL: String
    var type: String
    var previewHeight: Int
    var tags: String
    var downloads: Int
    var user: String
    var favorites: Int
    var imageSize: Int
    var previewWidth: Int
    var userImageURL: String
    var previewURL: String
    
    // Use coding keys to map "user_id" to "userId"
    // If you remap one JSON field you have to supply all the other unmapped fields too
    enum CodingKeys: String, CodingKey {
        case largeImageURL
        case webformatHeight
        case webformatWidth
        case likes
        case imageWidth
        case id
        case userId = "user_id"
        case views
        case comments
        case pageURL
        case imageHeight
        case webformatURL
        case type
        case previewHeight
        case tags
        case downloads
        case user
        case favorites
        case imageSize
        case previewWidth
        case userImageURL
        case previewURL
    }
}
