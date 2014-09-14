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
    
    let dictObjects = NSArray(objects: "title", "year", "mpaa_rating", "runtime", "ratings", "synopsis", "posters")
    
    var moviesArray: NSArray?
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.blackColor();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Rotten Tomatoes DVDs
        let YourApiKey = "8upky4adwajswdr73bufgjwg"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            if(error == nil) {
                if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary {
                    self.moviesArray = dictionary["movies"] as? NSArray
                    self.movieList.reloadData()
                }
            } else {
                // TODO: Network Error
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
        let cell = movieList.dequeueReusableCellWithIdentifier("com.tianyu.Tomato.movieCell") as MovieTableViewCell
        let movieDictionary = self.moviesArray![indexPath.row] as NSDictionary
        let thumbnailURL = NSURL.URLWithString((movieDictionary["posters"] as NSDictionary)["thumbnail"] as String)
        var err: NSError?
        var thumbnailImageData :NSData = NSData.dataWithContentsOfURL(thumbnailURL,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        
        cell.movieTitleLabel.text = movieDictionary["title"] as NSString
        cell.movieYearLabel.text = String(movieDictionary["year"] as Int)
        cell.movieRatingLabel.text = movieDictionary["mpaa_rating"] as NSString
        cell.movieScoreLabel.text = String((movieDictionary["ratings"] as NSDictionary)["audience_score"] as Int) + "/100"
        cell.movieDescriptionLabel.text = movieDictionary["synopsis"] as NSString
        cell.movieDescriptionLabel.numberOfLines = 0;
        cell.moviePosterImage.image = UIImage(data: thumbnailImageData)
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
        
        let detailsViewController = DetailsViewController(nibName: nil, bundle: nil)
        detailsViewController.detailsDictionary = detailsDictionary as NSDictionary
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

