//
//  PropertyFileHelper.swift
//  ImageApiDemo
//
//  Created by Russell Archer on 20/06/2018.
//  Copyright © 2018 Russell Archer. All rights reserved.
//

import UIKit

/*
 
 PropertyFileHelper reads the contents of a .plist file and allows you to read individual
 properties by their keys.
 
 Example usage:
 
 let _plistHelper = PropertyFileHelper(file: "MyPlistFile")  // Note: No .plist file extn
 guard _plistHelper.hasLoadedProperties else { return }
 guard var myValue = _plistHelper.readProperty(key: "MyKey") else { return }
 
 */

public class PropertyFileHelper {
    fileprivate var _propertyFile: [String : AnyObject]?

    public var hasLoadedProperties: Bool { return _propertyFile != nil ? true : false }
    
    init(file: String) {
        _propertyFile = readPropertyFile(filename: file)
    }
    
    /// Read a property from a dictionary of values that was read from a plist
    public func readProperty(key: String) -> String? {
        guard _propertyFile != nil else { return nil }
        if let value = _propertyFile![key] as? String {
            return value
        }
        
        return nil
    }
    
    /// Read a plist property file and return a dictionary of values
    public func readPropertyFile(filename: String) -> [String : AnyObject]? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            if let contents = NSDictionary(contentsOfFile: path) as? [String : AnyObject] {
                return contents
            }
        }
        
        return nil  // [:]
    }
}
