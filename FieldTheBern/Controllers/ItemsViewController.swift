//
//  ItemsViewController.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ItemsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var queue = NSOperationQueue()
    var items = [FTBItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let navigationAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-Medium", size: 16)!]
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(navigationAttributes, forState: .Normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(navigationAttributes, forState: .Normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(navigationAttributes, forState: .Normal)
        
        self.collectionView?.indicatorStyle = UIScrollViewIndicatorStyle.White
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    //
    // MARK: Collection View Methods
    //
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FTBConfig.ItemCollectionCell, forIndexPath: indexPath) as! ItemCollectionCell
        let item = items[indexPath.row]
        
        cell.itemTitleLabel.text = item.title
        
        if let imageUrl = NSURL(string: item.imageURLStr) {
            let layout = collectionView.collectionViewLayout
            let size = self.collectionView(collectionView, layout: layout, sizeForItemAtIndexPath: indexPath)
            cell.setImageURL(imageUrl, size: size)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = min(collectionView.bounds.width, collectionView.bounds.height)
        return CGSizeMake(width/2.0, width/2.0)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let item = items[indexPath.row]
        
        if let page = item as? PageModel {
            if let pageController = UIStoryboard.pageDetailViewControllerWithPage(page) {
                navigationController?.pushViewController(pageController, animated: true)
            }
        }
        else if let itemCollection = item as? ItemCollectionModel {
            if let collectionController = UIStoryboard.itemsCollectionViewControllerWithItems(item, items: itemCollection.allItems()) {
                navigationController?.pushViewController(collectionController, animated: true)
            }
        }
    }
    
}