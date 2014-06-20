//
//  CYFastImage.swift
//  CYFastImage
//
//  Created by jason on 14-6-19.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import Foundation
import UIKit

struct CYFastImage{
    static var sharedImageCache = CYImageCache()
    static var sharedImageDownloader = CYImageDownloader()
    static var sharedImageManager = CYImageManager()
}

func DEBUG_LOG(format: String, args: CVarArg...) {
    NSLog(format, args)
}
