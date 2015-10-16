//
//  ScoreContainerViewController.swift
//  GroundGame
//
//  Created by Josh Smith on 10/15/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ScoreContainerViewController: UIViewController {

    @IBOutlet weak var gifContainer: UIImageView!

    let images = ["bernie-ellen", "bernie", "bernie-shrug", "bernie-dancing", "bernie-dance"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadBernieGif()

        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func loadBernieGif() {
        let randomIndex = Int(arc4random_uniform(UInt32(images.count)))
        let imageName = images[randomIndex]
        
        if let path = NSBundle.mainBundle().pathForResource(imageName, ofType: "gif") {
            if let data = NSData(contentsOfFile: path) {
                let imageSize = 100.0
                let imageSizeFloat = CGFloat(imageSize)
                let image = FLAnimatedImage(animatedGIFData: data)
                let imageView: FLAnimatedImageView = FLAnimatedImageView()
                imageView.animatedImage = image
                imageView.frame = CGRectMake(3, 3, imageSizeFloat, imageSizeFloat)
                
                let innerFrame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
                let maskLayer = CAShapeLayer()
                let circlePath = UIBezierPath(roundedRect: innerFrame, cornerRadius: imageSizeFloat)
                maskLayer.path = circlePath.CGPath
                maskLayer.fillColor = UIColor.whiteColor().CGColor
                
                imageView.layer.mask = maskLayer
                
                gifContainer.addSubview(imageView)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedBackToMap(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
