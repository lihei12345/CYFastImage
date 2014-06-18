//
//  ViewController.swift
//  CYFastImage
//
//  Created by jason on 14-6-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView_: UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView_.setImageURL("", placeHolderImage: UIImage(named: "125.jpg"));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

