//
//  DetailsViewController.swift
//  Tomato
//
//  Created by Tianyu Shi on 9/13/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var criticScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var criticScoreImageView: UIImageView!
    @IBOutlet weak var audienceScoreImageView: UIImageView!
    
    var detailsDictionary: NSDictionary?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(detailsDictionary != nil) {
            let originalImageURL = NSURL.URLWithString((detailsDictionary!["posters"] as NSDictionary)["original"] as String)
            var err: NSError?
            var originalImageData :NSData = NSData.dataWithContentsOfURL(originalImageURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            
            posterImageView.image = UIImage(data: originalImageData)
            titleLabel.text = detailsDictionary!["title"] as NSString
            yearLabel.text = String(detailsDictionary!["year"] as Int)
            ratingLabel.text = detailsDictionary!["mpaa_rating"] as NSString
            synopsisLabel.text = detailsDictionary!["synopsis"] as NSString
            synopsisLabel.numberOfLines = 0;
            runtimeLabel.text = detailsDictionary!["runtime"] as NSString
            audienceScoreLabel.text = String((detailsDictionary!["ratings"] as NSDictionary)["audience_score"] as Int)
        }
    }
}
