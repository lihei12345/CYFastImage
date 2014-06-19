//
//  UIImageView+FastImage.swift
//  CYFastImage
//
//  Created by jason on 14-6-17.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImageURL(url: NSString!, placeHolderImage: UIImage!) {
        if placeHolderImage {
            self.image = placeHolderImage
        } else {
            self.image = nil
        }
        
        
        if url {
            CYFastImage.sharedImageDownloader.downloadImage(url){
                [weak self]
                (image:UIImage!, urlString: String!) -> Void in
                if image {
                    if self {
                        self!.image = image
                        self!.setNeedsLayout()
                    }
                }
            }
        }
    }
}