//
//  PageDetailViewController.swift
//  FeelTheBern
//
//  Created by Robert Maciej Pieta on 8/18/15.
//  Copyright © 2015 Onenigma. All rights reserved.
//

import Foundation
import UIKit
import Social

// UITableViewCellAutomaticDimension is not used because of incorrect behavior of trying to calculate the height related to the UITextView inside of a UITableViewCell.
class PageDetailViewController: UITableViewController {
    var page: PageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //
    // MARK: TableView Methods
    //
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let page = page else { return 0 }
        return page.getContentModels().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let page = page else { return UITableViewCell() }
        let model = page.getContentModels()[indexPath.row]
        
        switch model {
            case let header as HeaderModel:
                return labelContentCell(FTBConfig.HeaderCell, indexPath: indexPath, model: header)
            
            case let title as TitleModel:
                return labelContentCell(FTBConfig.TitleCell, indexPath: indexPath, model: title)

            case let subtitle as SubtitleModel:
                return labelContentCell(FTBConfig.SubtitleCell, indexPath: indexPath, model: subtitle)

            case let caption as CaptionModel:
                return labelContentCell(FTBConfig.CaptionCell, indexPath: indexPath, model: caption)

            case let paragraph as ParagraphModel:
                return paragraphContentCell(FTBConfig.ParagraphCell, indexPath: indexPath, model: paragraph)

            case let list as ListModel:
                return listContentCell(FTBConfig.ParagraphCell, indexPath: indexPath, model: list)

            case let image as ImageModel:
                return imageContentCell(FTBConfig.ImageCell, indexPath: indexPath, model: image)

            case let video as VideoModel:
                return videoContentCell(FTBConfig.VideoCell, indexPath: indexPath, model: video)
        
            default:
                return UITableViewCell()
        }
    }
    
    //
    // MARK: Cell Methods
    //
    
    func labelContentCell(identifier: String, indexPath: NSIndexPath, model: TextModel) -> LabelContentCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! LabelContentCell
        cell.contentLabel.text = model.text
        return cell
    }

    func paragraphContentCell(identifier: String, indexPath: NSIndexPath, model: ParagraphModel) -> TextViewContentCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FTBConfig.ParagraphCell, forIndexPath: indexPath) as! TextViewContentCell

        let attrString = attributedStringForText(model.paragraph, links: model.links)
        cell.contentTextView.attributedText = attrString
        
        cell.contentTextView.font = FTBConfig.ParagraphFont
        cell.contentTextView.contentInset = UIEdgeInsetsZero
        cell.contentTextView.textContainerInset = UIEdgeInsetsZero
        cell.contentTextView.textContainer.lineFragmentPadding = 0
        
        return cell
    }

    func listContentCell(identifier: String, indexPath: NSIndexPath, model: ListModel) -> TextViewContentCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! TextViewContentCell
        cell.contentTextView.text = model.text
        return cell
    }

    func sizeForImageCell(cell: ImageContentCell, indexPath: NSIndexPath) -> CGSize {
        let horizontalPadding = cell.leftPaddingLayoutConstraint.constant + cell.rightPaddingLayoutConstraint.constant
        let verticalPadding = cell.topPaddingLayoutConstraint.constant + cell.bottomPaddingLayoutConstraint.constant
        let height = self.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return CGSizeMake(tableView.bounds.width - horizontalPadding, height - verticalPadding)
    }
    
    func imageContentCell(identifier: String, indexPath: NSIndexPath, model: ImageModel) -> ImageContentCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ImageContentCell
        
        if let url = NSURL(string: model.imageURLString) {
            let size = sizeForImageCell(cell, indexPath: indexPath)
            cell.setImageURL(url, size: size)
        }
        else {
            cell.contentImageView.image = nil
        }
        cell.setActionDestinationURLString(model.sourceURLString)
        
        return cell
    }
    
    
    func videoContentCell(identifier: String, indexPath: NSIndexPath, model: VideoModel) -> ImageContentCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ImageContentCell
        
        if let url = NSURL(string: "http://img.youtube.com/vi/"+model.youtubeId+"/hqdefault.jpg") {
            let size = sizeForImageCell(cell, indexPath: indexPath)
            cell.setImageURL(url, size: size)
        }
        else {
            cell.contentImageView.image = nil
        }
        cell.setActionDestinationURLString(model.videoURLString)
        
        return cell
    }
    
    //
    // MARK: Cell Size Methods
    //
    
    func heightForText(text: String, font: UIFont, width: CGFloat, horizontalPad: CGFloat, verticalPad: CGFloat) -> CGFloat {
        let width = floor(width - horizontalPad)
        let size = (text as NSString).boundingRectWithSize(CGSizeMake(width, CGFloat.max),
            options: [.UsesLineFragmentOrigin, .UsesFontLeading],
            attributes: [NSFontAttributeName : font],
            context: nil
            ).size
        
        return ceil(size.height) + verticalPad
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let page = page else { return 0.0 }
        let model = page.getContentModels()[indexPath.row]
        let width = tableView.bounds.width

        switch model {
            case let header as HeaderModel:
                return heightForText(header.text, font: FTBConfig.HeaderFont!, width: width, horizontalPad: 16.0, verticalPad: 16.0)

            case let title as TitleModel:
                return heightForText(title.text, font: FTBConfig.TitleFont!, width: width, horizontalPad: 16.0, verticalPad: 16.0)

            case let subtitle as SubtitleModel:
                return heightForText(subtitle.text, font: FTBConfig.SubtitleFont!, width: width, horizontalPad: 16.0, verticalPad: 12.0)

            case let caption as CaptionModel:
                return heightForText(caption.text, font: FTBConfig.CaptionFont!, width: width, horizontalPad: 16.0, verticalPad: 16.0)

            case let paragraph as ParagraphModel:
                return heightForText(paragraph.paragraph, font: FTBConfig.ParagraphFont!, width: width, horizontalPad: 16.0, verticalPad: 8.0)

            case let list as ListModel:
                return heightForText(list.text, font: FTBConfig.ParagraphFont!, width: width, horizontalPad: 16.0, verticalPad: 4.0)

            case let image as ImageModel:
                if image.width > 0 && image.height > 0 {
                    let widthAdjustment = CGFloat(tableView.bounds.width) / CGFloat(image.width)
                    return CGFloat(image.height) * widthAdjustment
                }
                else { return 0.0 }

            case let video as VideoModel:
                if video.youtubeId != "" {
                    let width: CGFloat = tableView.bounds.width - 16.0
                    let youtubeAspectRatio: CGFloat = 4.0/3.0 // Width / Height
                    return (width / youtubeAspectRatio) + 16.0
                }
                else { return 0.0 }

            default:
                return 0.0
        }
    }
    
    //
    // MARK: Attributed Size
    // 
    
    func attributedStringForText(text: String, links: [LinkModel]) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        attrString.highlightLinks(links)
        return attrString
    }
    
    //
    // MARK: Share Methods
    //
    
    @IBAction func sharePushed() {
        let actionController = UIAlertController.socialAlertControllerForPage(page, parentViewController: self)        
        presentViewController(actionController, animated: true, completion: nil)
    }
}