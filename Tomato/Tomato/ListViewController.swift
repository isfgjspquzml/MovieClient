//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Tianyu Shi on 9/10/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var movieList: UITableView!
    
    var moviesArray: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Rotten Tomatoes DVDs
        let YourApiKey = "8upky4adwajswdr73bufgjwg"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary {
                self.moviesArray = dictionary["movies"] as? NSArray
                self.movieList.reloadData()
            } else {
                // TODO: Something went wrong
            }
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(moviesArray != nil) {
            return moviesArray!.count
        } else {
            return 0
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieList.dequeueReusableCellWithIdentifier("com.tianyu.Rotten-Tomatoes.movieCell") as MovieTableViewCell
        let movieDictionary = self.moviesArray![indexPath.row] as NSDictionary
        cell.movieTitleLabel.text = movieDictionary["title"] as NSString
        cell.movieYearLabel.text = String(movieDictionary["year"] as Int)
        cell.movieRatingLabel.text = movieDictionary["mpaa_rating"] as NSString
        cell.movieScoreLabel.text = String((movieDictionary["ratings"] as NSDictionary)["audience_score"] as Int)
        cell.movieDescriptionLabel.text = movieDictionary["synopsis"] as NSString
        cell.movieDescriptionLabel.numberOfLines = 0;
        
        return cell
    }
}

