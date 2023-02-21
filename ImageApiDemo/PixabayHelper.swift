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
        
        guard searchFor.count > 2 else { return }
        guard _plistHelper.hasLoadedProperties else { return }
        
        // Example query: https://pixabay.com/api/?key=your-api-key&image_type=photo&q=coffee
        guard var pixabayUrl = _plistHelper.readProperty(key: "PixabayUrl") else { return }
        guard let pixabayApiKey = _plistHelper.readProperty(key: "PixabayApiKey") else { return }
        guard let pixabayImageType = _plistHelper.readProperty(key: "PixabayImageType") else { return }
        
        pixabayUrl += pixabayApiKey + "&" + pixabayImageType + "&q=" + searchFor
        
        let url = URL(string: pixabayUrl)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] (json, response, error) in
            guard let self = self else { return }
            guard json != nil else { return }

            let httpResponse = response as! HTTPURLResponse
            print("HTTP response status code: \(httpResponse.statusCode)")  // 200 == OK
            
            guard httpResponse.statusCode == 200 else {
                print("The HTTP response status code indicates there was an error")
                return
            }

            // This is the Swift 4 type-safe method of parsing the JSON received from Pixabay.
            // See the model PixabayData used to map the JSON
            let decoder = JSONDecoder()
            let dataModelType = PixabayData.self
            self.pixabayData = try? decoder.decode(dataModelType, from: json!)
            
            guard self.pixabayData != nil else { return }

            // Call our delegate(s) to let them know data is available.
            // Because we're currently not running on the main thread we explicitly call the delegate
            // on the main thread in case they try to update the UI (which would throw an exception)
            DispatchQueue.main.async(execute: {
                self.delegate?.dataDidLoad()
            })
        }

        task.resume()
    }
}
