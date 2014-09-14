//
//  DetailsViewController.swift
//  Tomato
//
//  Created by Tianyu Shi on 9/13/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

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

            
    }
}
