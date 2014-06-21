//
//  CYImageDownloader.swift
//  CYFastImage
//
//  Created by jason on 14-6-19.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import Foundation
import UIKit

extension CYFastImage {
    class CYImageDownloader {
        var operationQueue: NSOperationQueue!
        var concurrentCount: Int
        
        init(concurrentCount: Int) {
            self.concurrentCount = concurrentCount
            operationQueue = NSOperationQueue()
            operationQueue.maxConcurrentOperationCount = concurrentCount
        }
        
        convenience init() {
            self.init(concurrentCount: 2)
        }
        
        // MARK: public
        func downloadImage(url: String, callback: DownloadCallback) {
            var operation = CYDownloadOperation()
            operation.urlString = url
            operation.finishCallback = callback
            operationQueue.addOperation(operation)
        }
        
        func cancel(url: String!) {
            for operation : AnyObject in operationQueue.operations {
                if let downloadOperation =  operation as? CYDownloadOperation {
                    if url == downloadOperation.urlString {
                        downloadOperation.cancel()
                    }
                }
            }
        }
        
        func isDownloadingImage(url: String!) -> Bool {
            for operation : AnyObject in operationQueue.operations {
                if let downloadOperation =  operation as? CYDownloadOperation {
                    if url == downloadOperation.urlString {
                        return true
                    }
                }
            }
            return false
        }
    }
}
