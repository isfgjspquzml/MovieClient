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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var criticScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var criticScoreImageView: UIImageView!
    @IBOutlet weak var audienceScoreImageView: UIImageView!
    
    lazy var thumbsUp = UIImage(named: "thumbsup.png")
    lazy var thumbsDown = UIImage(named: "thumbsdown.png")
    var detailsDictionary: NSDictionary?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(detailsDictionary != nil) {
            let imageStringURL = (detailsDictionary!["posters"] as NSDictionary)["original"] as String
            let imageURL = NSURL.URLWithString(imageStringURL)
            let highResStringURL = imageStringURL.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
            let highResURL = NSURL.URLWithString(highResStringURL)
            let audienceScore = (detailsDictionary!["ratings"] as NSDictionary)["audience_score"] as Int
            let criticScore = (detailsDictionary!["ratings"] as NSDictionary)["critics_score"] as Int
            var err: NSError?
            var imageData :NSData = NSData.dataWithContentsOfURL(highResURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            
            posterImageView.image = UIImage(data: imageData)
            titleLabel.text = detailsDictionary!["title"] as NSString + "(" + String(detailsDictionary!["year"] as Int) + ")"
            ratingLabel.text = detailsDictionary!["mpaa_rating"] as NSString
            synopsisLabel.text = detailsDictionary!["synopsis"] as NSString
            synopsisLabel.numberOfLines = 0;
            runtimeLabel.text = String(detailsDictionary!["runtime"] as Int)
            audienceScoreLabel.text = String(audienceScore)
            criticScoreLabel.text = String(criticScore)
            audienceScoreImageView.image = (audienceScore > 50) ? thumbsUp : thumbsDown
            criticScoreImageView.image = (criticScore > 50) ? thumbsUp : thumbsDown
        }
    }
}
