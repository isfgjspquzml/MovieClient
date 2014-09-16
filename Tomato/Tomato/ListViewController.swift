//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Tianyu Shi on 9/10/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var movieList: UITableView!
    @IBOutlet var errorView: UIView!
    
    let dictObjects = NSArray(objects: "title", "year", "mpaa_rating", "runtime", "ratings", "synopsis", "posters")
    
    lazy var fileNotFound = UIImage(named: "filenotfound.png")
    var moviesArray: NSArray?
    var dismissed: Bool?
    var refreshControl: UIRefreshControl?
    
    override func viewWillAppear(animated: Bool) {
        self.movieList.backgroundColor = UIColor.darkGrayColor()
        self.movieList.tintColor = UIColor.whiteColor()
        self.movieList.separatorColor = UIColor.whiteColor()
        self.title = "Box Office Hits"
        errorView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.darkGrayColor()
        refreshControl?.tintColor = UIColor.whiteColor()
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        movieList.addSubview(refreshControl!)
        
        // Show loading
        dismissed = false
        SVProgressHUD.show()
        getMovieData()
    }
    
    func getMovieData() {
        // Get Rotten Tomatoes DVDs
        let YourApiKey = "8upky4adwajswdr73bufgjwg"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            if(error == nil) {
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary {
                    self.moviesArray = dictionary["movies"] as? NSArray
                    self.errorView.hidden = true
                    self.movieList.reloadData()
                }
            } else {
                self.errorView.hidden = false
            }
        })
    }
    
    func refresh(sender:AnyObject)
    {
        getMovieData()
        movieList.reloadData()
        
        if(refreshControl != nil) {
            let dateFormater = NSDateFormatter()
            dateFormater.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
            let title = "Updated " + dateFormater.stringFromDate(NSDate())
            let attrDict = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
            let attrString = NSAttributedString(string: title, attributes: attrDict)
            refreshControl!.attributedTitle = attrString
            refreshControl?.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(moviesArray != nil) {
            movieList.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return moviesArray!.count
        } else {
            SVProgressHUD.dismiss()
            
            // Display a message when the table is empty
            let rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
            var messageLabel = UILabel( frame: rect)
            messageLabel.text = "Pull down to refresh"
            messageLabel.textColor = UIColor.whiteColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            
            movieList.backgroundView = messageLabel
            movieList.separatorStyle = UITableViewCellSeparatorStyle.None
            
            return 0
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieList.dequeueReusableCellWithIdentifier("com.tianyu.Tomato.movieCell") as MovieTableViewCell
        let movieDictionary = self.moviesArray![indexPath.row] as NSDictionary
        
        let thumbnailURL = NSURL.URLWithString((movieDictionary["posters"] as NSDictionary)["thumbnail"] as String)
        let thumbnailURLRequest = NSURLRequest(URL: thumbnailURL)
        let thumbnailRequest = AFHTTPRequestOperation(request: thumbnailURLRequest)
        thumbnailRequest.responseSerializer = AFImageResponseSerializer()
        thumbnailRequest.setCompletionBlockWithSuccess(
            {(operation: AFHTTPRequestOperation!, obj) in
                cell.moviePosterImage.image = obj as? UIImage
                UIView.animateWithDuration(1, animations: {
                    cell.moviePosterImage.alpha = 1
                })
            },
            failure: {(operation: AFHTTPRequestOperation!, obj) in
                cell.moviePosterImage.image = self.fileNotFound
        })
        thumbnailRequest.start()
        
        cell.movieTitleLabel.text = movieDictionary["title"] as NSString
        cell.movieYearLabel.text = String(movieDictionary["year"] as Int)
        cell.movieRatingLabel.text = movieDictionary["mpaa_rating"] as NSString
        
        let rating = (movieDictionary["ratings"] as NSDictionary)["audience_score"] as Int
//        cell.movieScoreLabel.textColor = (rating < 50) ? UIColor(red: 1, green: 0.86, blue: 0.86, alpha: 1) : UIColor(red: 0.86, green: 1, blue: 0.86, alpha: 1)
        cell.movieScoreLabel.text = String(rating) + "/100"
        
        cell.movieDescriptionLabel.text = movieDictionary["synopsis"] as NSString
        cell.movieDescriptionLabel.numberOfLines = 0;
        
        if(!dismissed!) {
            SVProgressHUD.dismiss()
            dismissed = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let movieDictionary = self.moviesArray![indexPath.row] as NSDictionary
        var detailsDictionary = NSMutableDictionary(capacity: dictObjects.count)
        
        for i in 0...(dictObjects.count - 1) {
            var key = dictObjects[i] as String
            var value: AnyObject? = movieDictionary[key]
            detailsDictionary.setValue(value, forKey: key)
        }
        
        let detailsViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailsViewController.detailsDictionary = detailsDictionary as NSDictionary
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

