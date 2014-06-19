//
//  ViewController.swift
//  CYFastImage
//
//  Created by jason on 14-6-17.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView_: UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var image = imageView_.image;
        imageView_.backgroundColor = UIColor.redColor()
        // Do any additional setup after loading the view, typically from a nib.
        imageView_.setImageURL("http://b.hiphotos.baidu.com/image/pic/item/267f9e2f070828385ee83f10ba99a9014d08f1c9.jpg", placeHolderImage: UIImage(named: "125.jpg"));
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

