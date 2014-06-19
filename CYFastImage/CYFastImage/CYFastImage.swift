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
    static var sharedImageDownloader = CYImageDownloader()
    
    class CYImageDownloader {
        var operationQueue: NSOperationQueue!
        init() {
            operationQueue = NSOperationQueue()
            operationQueue.maxConcurrentOperationCount = 5
        }
        
        func downloadImage(url: String, callback: (UIImage? -> Void)) {
            var operation = CYDownloadOperation()
            operation.urlString = url
            operation.finishCallback = callback
            operationQueue.addOperation(operation)
        }
    }
}