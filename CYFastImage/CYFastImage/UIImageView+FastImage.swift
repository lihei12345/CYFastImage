//
//  UIImageView+FastImage.swift
//  CYFastImage
//
//  Created by jason on 14-6-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageURL(url: NSString?, placeHolderImage: UIImage?) {
        if let tmpImage = placeHolderImage {
            self.image = tmpImage
        } else {
            self.image = nil
        }
        
        self.contentMode = UIViewContentMode.ScaleAspectFit
    }
}