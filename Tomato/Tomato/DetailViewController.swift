//
//  DetailViewController.swift
//  Tomato
//
//  Created by Tianyu Shi on 9/13/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var criticScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var criticScoreImageView: UIImageView!
    @IBOutlet weak var audienceScoreImageView: UIImageView!
    
    lazy var thumbsUp = UIImage(named: "thumbsup.png")
    lazy var thumbsDown = UIImage(named: "thumbsdown.png")
    var bottomY: CGFloat?
    var detailsDictionary: NSDictionary?
    var loaded: Bool?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        loaded = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!loaded!) {
            SVProgressHUD.show()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomY = detailView.frame.size.height
        if(detailsDictionary != nil) {
            // Load low resolution image
            let imageStringURL = (detailsDictionary!["posters"] as NSDictionary)["original"] as String
            let imageURL = NSURL.URLWithString(imageStringURL)
            var err: NSError?
            var imageData :NSData = NSData.dataWithContentsOfURL(imageURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            posterImageView.image = UIImage(data: imageData)
            
            UIView.animateWithDuration(1, animations: {
                self.posterImageView.alpha = 1
            })
            
            let highResStringURL = imageStringURL.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
            let highResURL = NSURL.URLWithString(highResStringURL)
            let highResURLRequest = NSURLRequest(URL: highResURL)
            let highResRequest = AFHTTPRequestOperation(request: highResURLRequest)
            highResRequest.responseSerializer = AFImageResponseSerializer()
            highResRequest.setCompletionBlockWithSuccess(
                {(operation: AFHTTPRequestOperation!, obj) in
                    self.posterImageView.image = obj as? UIImage
                    SVProgressHUD.dismiss()
                    self.loaded = true
                },
                failure: {(operation: AFHTTPRequestOperation!, obj) in
                    NSLog("Image error")
            })
            highResRequest.start()
            
            detailView.sendSubviewToBack(posterImageView)
            titleLabel.text = detailsDictionary!["title"] as NSString + " (" + String(detailsDictionary!["year"] as Int) + ")"
            ratingLabel.text = detailsDictionary!["mpaa_rating"] as NSString
            
            synopsisTextView.text = detailsDictionary!["synopsis"] as NSString

            // Resize the textview
            var frameSize = CGSize(width: synopsisTextView.frame.size.width, height: CGFloat.max)
            var frameHeight = synopsisTextView.sizeThatFits(frameSize)
            synopsisTextView.frame.size.height = frameHeight.height
            
            runtimeLabel.text = String(detailsDictionary!["runtime"] as Int) + " MIN"
            let audienceScore = (detailsDictionary!["ratings"] as NSDictionary)["audience_score"] as Int
            let criticScore = (detailsDictionary!["ratings"] as NSDictionary)["critics_score"] as Int
            audienceScoreLabel.text = String(audienceScore)
            criticScoreLabel.text = String(criticScore)
            audienceScoreImageView.image = (audienceScore > 50) ? thumbsUp : thumbsDown
            criticScoreImageView.image = (criticScore > 50) ? thumbsUp : thumbsDown
            
            // Resize information view
            var totalHeight: CGFloat = 0
            for (index, view: UIView) in enumerate(informationView.subviews as [UIView]) {
                if(totalHeight < view.frame.origin.y + view.frame.size.height) {
                    totalHeight = view.frame.origin.y + view.frame.size.height;
                }
            }
            
            let moveDist = totalHeight/2 - titleLabel.frame.size.height
            informationView.frame.size.height = totalHeight
            informationView.center.y = bottomY! + moveDist
        }
    }
    
    @IBAction func informationViewOnPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        let translatedY = sender.view!.center.y + translation.y
        let minY = bottomY! - informationView.frame.size.height/2
        let maxY = bottomY! - titleLabel.frame.size.height + informationView.frame.size.height/2
        var fixedY = (translatedY > minY) ? translatedY : minY
        fixedY = (fixedY < maxY) ? fixedY : maxY
        
        sender.view!.center = CGPoint(x:sender.view!.center.x, y:fixedY)
        sender.setTranslation(CGPointZero, inView: self.view)
    }
}
