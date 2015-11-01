//
//  TopicsDownloadOperation.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import RealmSwift

class TopicsDownloadOperation: FTBOperation {
    var items = [FTBItemModel]()
    
    //
    // MARK: Lifecycle Methods
    //
    
    override func start() {
        super.start()
        
        let session = NSURLSession.sharedSession()
        guard let url = NSURL(string: FTBConfig.wordpressTopicsURLStr) else { state = .Finished; return; }
        let request = NSURLRequest(URL: url)

        dataTask = session.dataTaskWithRequest(request) { [weak self] (data, response, error) -> Void in

            defer {
                self?.state = .Finished;
            }
            
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let realm = try Realm()
                realm.beginWrite()
                
                self?.itemDictionariesFromData(data).mapTo { (itemDictionary: NSDictionary) in
                    guard let item = ModelMap.modelForDictionary(itemDictionary) as? FTBItemModel else { return }
                    self?.items.append(item)
                    item.superlevel = true
                    
                    guard item.isValid() else { return }
                    realm.add(item, update: true)
                }
                
                do {
                    try realm.commitWrite()
                } catch let error {
                    // Handling write error,
                    // e.g. Delete the Realm file, etc.
                }

            }
            catch _ {}
        }
        
        dataTask?.resume()
    }
    
    //
    // MARK: Data Methods
    //
    
    func itemDictionariesFromData(data: NSData) -> NSArray {
        do {
            guard let homeCollection = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary else { return NSArray() }
            guard let itemDictionaries = homeCollection["items"] as? NSArray else { return NSArray() }
            return itemDictionaries
        }
        catch _ {}
        return NSArray()
    }
}