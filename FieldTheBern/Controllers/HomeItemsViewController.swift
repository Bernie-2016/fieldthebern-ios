//
//  HomeItemsViewController.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/29/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class HomeItemsViewController: ItemsViewController {
    var topicsReloaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        self.items = superlevelItemModels()
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        didBecomeActive(nil)
    }
    
    func didBecomeActive(notification: NSNotification?) {
        if topicsReloaded {
            let items = superlevelItemModels()
                
            if items.count != self.items.count {
                self.items = items
                self.collectionView?.reloadData()
            }
        }
        
        guard !topicsReloaded else { return }
        reloadTopics()
    }
    
    //
    // MARK: Topic Methods
    //
    
    func reloadTopics() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if reachability?.isReachable() == false {
            if superlevelItemModels().count > 0 {} // Offline mode
            else {
                let alertController = UIAlertController.errorAlertControllerWithTitle(FTBConfig.NoInternetErrorTitle, message: FTBConfig.NoInternetErrorMessage)
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else {
            topicsReloaded = true
            
            let operation = TopicsDownloadOperation()
            operation.completionBlock = { [weak self] in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.checkIfTopicImagesAreCached()
                    
                    let shouldReloadData = (self?.items.count == 0)
                    if let items = self?.superlevelItemModels() { self?.items = items }
                    if shouldReloadData { self?.collectionView?.reloadData() }
                })
            }
            
            queue.addOperation(operation)
        }
    }
    
    
    //
    // MARK: Realm Methods
    //
    
    func checkIfTopicImagesAreCached() {
        guard let collectionView = self.collectionView else { return }
        let width = min(collectionView.bounds.width, collectionView.bounds.height)
        let size = CGSizeMake(width/2.0, width/2.0)
        
        let operation = TopicsImageCacheOperation(size: size, overlayColor: UIColor(white: 0.0, alpha: 0.35))
        queue.addOperation(operation)
    }
    
    func superlevelItemModels() -> [FTBItemModel] {
        do {
            let realm = try Realm()
            var items = [FTBItemModel]()
            
            for item in realm.objects(PageModel).filter("superlevel = YES") { items.append(item) }
            for item in realm.objects(ItemCollectionModel).filter("superlevel = YES") { items.append(item) }
            return items
        }

        catch _ {}
        return [FTBItemModel]()
    }
    
    //
    // MARK: Action Methods
    //
    
    @IBAction func morePushed() {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for (key,value) in FTBConfig.MoreLinksMap {
            let linkAction = UIAlertAction(title: key, style: .Default, handler: { (action) -> Void in
                guard let url = NSURL(string: value), _ = url.path else { return }
                UIApplication.sharedApplication().openURL(url)
            })
            actionController.addAction(linkAction)
        }
        
        actionController.addAction(UIAlertAction.cancelAction())
        presentViewController(actionController, animated: true, completion: nil)
    }
    
    // MARK: - CollectionView Methods
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

            switch kind {
            case UICollectionElementKindSectionHeader:
                //3
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "CollectionActivityHeader",
                    forIndexPath: indexPath)
                return headerView
            default:
                fatalError("Unexpected element kind")
            }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.items.count > 0 {
            return CGSize.zero
        } else {
            return CGSize(width: self.view.frame.size.width, height: 50.0)
        }
    }
}