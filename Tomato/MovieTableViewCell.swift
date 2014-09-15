//
//  MovieTableViewCell.swift
//  Rotten Tomatoes
//
//  Created by Tianyu Shi on 9/12/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieScoreLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.darkGrayColor()
        
        var bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.blackColor()
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
