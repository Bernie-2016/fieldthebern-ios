//
//  CacheManager.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/24/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

class CacheManager: NSObject {
    static let sharedInstance = CacheManager()
    var cache = [String:NSData]()
    
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lowMemoryWarningRecieved:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //
    // MARK: Low Memory Warning
    //
    
    func lowMemoryWarningRecieved(notification: NSNotification) {
        cache.removeAll()
    }
    
    //
    // MARK: Cache Methods
    //
    
    func keyFromString(str: String) -> String {
        let lenght = (str as NSString).length
        
        // Prevents long strings from being shortened (tail gets cut) causing duplicate file names for long urls
        if lenght > 20 {
            let range = Range(start: str.startIndex.advancedBy(lenght - 20), end: str.endIndex)
            return str.substringWithRange(range)
        }
        else {
            return str
        }
    }
    
    func setObject(object: NSData, forKey key: String, cacheImmediately: Bool) {
        let keyString = keyFromString(key)
        saveObject(object, forKey: keyString)
        
        if cacheImmediately { cache[keyString] = object }
    }
    
    func objectForKey(key: String) -> NSData? {
        let keyString = keyFromString(key)
        if let object = cache[keyString] {
            return object
        }
        else if let object = objectFromFileWithKey(keyString) {
            cache[keyString] = object
            return object
        }
        else {
            return nil
        }
    }
    
    func objectForKeyExists(key: String) -> Bool {
        let keyString = keyFromString(key)
        if let _ = cache[keyString] { return true }
        else if let _ = objectFromFileWithKey(keyString) { return true }
        else { return false }
    }
    
    //
    // MARK: File System Methods
    //
    
    private func cacheSavePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let cachePath = paths[0]
        return cachePath
    }
    
    private func cachePathForKey(key: String) -> String {
        let cachePath = cacheSavePath()
        return cachePath + "/" + key
    }
    
    private func saveObject(object: NSData, forKey key: String) {
        let cachePath = cachePathForKey(key)
        object.writeToFile(cachePath, atomically: true)
    }
    
    private func objectFromFileWithKey(key: String) -> NSData? {
        let cachePath = cachePathForKey(key)
        return NSData(contentsOfFile: cachePath)
    }
}