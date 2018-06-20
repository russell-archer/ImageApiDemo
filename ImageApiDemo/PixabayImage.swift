//
//  PixabayImage.swift
//  ImageApiDemo
//
//  Created by Russell Archer on 18/06/2018.
//  Copyright © 2018 Russell Archer. All rights reserved.
//

/*
 
 The Codable protocol was introduced with in Swift 4
 
 This struct is Codable without having to explicitly conform to the Encodable and Decodable
 protocols because it uses standard library types like String, Int and Double. You can also
 use Foundation types like Date, Data, and URL. So, any type whose properties are codable
 automatically conforms to Codable.
 
 Adopting Codable on your own types enables you to serialize them to and from any of the
 built-in data formats, and any formats provided by custom encoders and decoders. For example,
 the PixabayImage structure can be encoded using both the PropertyListEncoder and JSONEncoder
 classes, even though PixabayImage itself contains no code to specifically handle property lists
 or JSON.
 
 Built-in collections such as Array and Dictionary also conform to Codable whenever they
 contain codable types.
 
 */

import Foundation

public struct PixabayImage: Codable {
    var id: String
    var previewURL: String
    var largeImageURL: String
    
    // Map the json fields. Note that you have to list all fields, including the ones you don't want to change
    private enum CodingKeys: String, CodingKey {
        case id
        case previewURL
        case largeImageURL
    }
}


