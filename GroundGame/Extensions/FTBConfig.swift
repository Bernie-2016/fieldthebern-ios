//
//  FTBConfig.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit

class FTBConfig {
    static let wordpressTopicsURLStr = "http://feelthebern.org/ftb-json/"
    
    //
    // MARK: More Links Map
    //
    
    static let MoreLinksMap = [
        "Register To Vote": "http://voteforbernie.org",
        "About Bernie Sanders": "http://feelthebern.org/who-is-bernie-sanders/",
        "Donate To The Campaign": "https://secure.actblue.com/contribute/page/reddit-for-bernie/",
        "Campaign Events": "http://www.bernie2016events.org",
        "Volunteer": "https://go.berniesanders.com/page/s/volunteer-for-bernie"
    ]
    
    //
    // MARK: JSON Dictionary Keys
    //
    
    static let TypeKey = "type"
    static let TitleKey = "title"
    static let URLKey = "url"
    static let TextKey = "text"
    static let WidthKey = "width"
    static let HeightKey = "height"
    static let CaptionKey = "caption"
    static let SourceKey = "source"
    static let VideoSourceKey = "src"
    static let StartKey = "start"
    static let EndKey = "end"
    static let LinksKey = "links"
    static let HREFKey = "href"
    static let IDKey = "id"
    static let ImageThumbKey = "image_url_thumb"
    static let ItemsKey = "items"
    static let ContentKey = "content"
    static let ListKey = "list"
    
    //
    // MARK: Segues
    //
    
    static let TopicDetailSegueIdentifier = "toTopicDetail"
    
    //
    // MARK: Cells
    //
    
    static let ItemCollectionCell = "ItemCollectionCell"
    static let ImageCell = "ImageCell"
    static let VideoCell = "VideoCell"
    
    static let HeaderCell = "HeaderCell"
    static let HeaderFont = UIFont(name: "Lato-Heavy", size: 20.0)
    
    static let TitleCell = "TitleCell"
    static let TitleFont = UIFont(name: "Lato-Heavy", size: 17.0)
    
    static let SubtitleCell = "SubtitleCell"
    static let SubtitleFont = UIFont(name: "Lato-Medium", size: 17.0)
    
    static let CaptionCell = "CaptionCell"
    static let CaptionFont = UIFont(name: "Lato-Medium", size: 14.0)

    static let ParagraphCell = "ParagraphCell"
    static let ParagraphFont = UIFont(name: "Lato-Medium", size: 14.0)
    
    //
    // MARK: Errors
    //
    
    static let NoInternetErrorTitle = "No Internet Connection"
    static let NoInternetErrorMessage = "Please connect to the internet before using Feel The Bern for the first time."
    
}