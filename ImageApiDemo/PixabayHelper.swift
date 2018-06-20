//
//  PixabayHelper.swift
//  ImageApiDemo
//
//  Created by Russell Archer on 20/06/2018.
//  Copyright © 2018 Russell Archer. All rights reserved.
//

import Foundation
import UIKit

protocol PixabayHelperDelegate {
    func dataDidLoad()
}

class PixabayHelper {
    public var pixabayData: PixabayData?  /// Holds decoded JSON data loaded from Pixabay
    public var delegate: PixabayHelperDelegate?  /// Used to notify when data has been loaded
    
    fileprivate let _plistHelper = PropertyFileHelper(file: "Pixabay")
    
    public func loadImages(searchFor: String) {
        print("Loading data from Pixabay...")
        
        guard _plistHelper.hasLoadedProperties else { return }
        guard var query = _plistHelper.readProperty(key: "PixabayQuery") else { return }
        guard let imageType = _plistHelper.readProperty(key: "PixabayImageType") else { return }
        
        query += "&" + imageType + "&q=" + searchFor
        
        let url = URL(string: query)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (json, response, error) in

            guard json != nil else { return }

            let httpResponse = response as! HTTPURLResponse
            print("HTTP response status code: \(httpResponse.statusCode)")  // 200 == OK
            
            guard httpResponse.statusCode == 200 else {
                print("The HTTP response status code indicates there was an error")
                return
            }

            // This is the Swift 4 type-safe method of parsing the JSON received from Pixabay.
            // See the model PixabayData used to map the JSON
            self.pixabayData = try? JSONDecoder().decode(PixabayData.self, from: json!)
            guard self.pixabayData != nil else { return }

            // Call our delegate to let them know data is available.
            // Because we're currently not running on the main thread we explicitly call the delegate
            // on the main thread in case they try to update the UI (which would throw an exception)
            DispatchQueue.main.async(execute: {
                self.delegate?.dataDidLoad()
            })
        }

        task.resume()
    }
    
    public func loadImagesSwift3() {
        guard _plistHelper.hasLoadedProperties else { return }
        guard var query = _plistHelper.readProperty(key: "PixabayQuery") else { return }
        guard let imageType = _plistHelper.readProperty(key: "PixabayImageType") else { return }
        
        query += "&" + imageType + "&q=coffee"
        
        let url = URL(string: query)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (json, response, error) in
            
            guard json != nil else { return }
            
            let httpResponse = response as! HTTPURLResponse
            print("HTTP response status: \(httpResponse.statusCode)")  // 200 == OK
            
            guard httpResponse.statusCode == 200 else {
                print("The HTTP response status code indicates there was an error")
                return
            }
            
            // This is the Swift 3 dictionary-based method of parsing the JSON received from Pixabay.
            // Parse the JSON into a dictionary which should have three elements: total, totalHits and hits,
            if let jsonArray = try? JSONSerialization.jsonObject(with: json!, options: []) as? [String : AnyObject] {
                if let hits = jsonArray!["hits"] as? [[String : Any]] {
                    for hit in hits {
                        if let id = hit["id"] {
                            print(id)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
}
