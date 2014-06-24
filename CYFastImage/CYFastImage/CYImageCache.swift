//
//  CYImageCache.swift
//  CYFastImage
//
//  Created by jason on 14-6-19.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import Foundation
import UIKit

extension CYFastImage{
    typealias ImageCacheCallback = (image: UIImage!, url: String!) -> Void
    
    class CYImageCache: NSObject {
        var cacheQueue: dispatch_queue_t!
        var defaultCachePath: String
        var fileManager: NSFileManager
        
        init() {
            cacheQueue = dispatch_queue_create("cyfastimage_cache_queue", nil)
            var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            defaultCachePath = paths[0] as NSString
            defaultCachePath = defaultCachePath.stringByAppendingPathComponent("com.chenyang.imagecache");
            
            fileManager = NSFileManager()
            
            super.init()
        }
        
        // MARK: public
        func getImage(url: String!, callback:ImageCacheCallback!) {
            if !url || !callback {
                return
            }
            
            var cachepath = getcachePath(url)
            var image = UIImage(contentsOfFile: cachepath)
            callback(image: image, url: url)
        }
        
        func saveImage(url: String!, data: NSData!) {
            if !url {
                return
            }
            
            if data {
                dispatch_async(cacheQueue){
                    if !self.fileManager.fileExistsAtPath(self.defaultCachePath) {
                        self.fileManager.createDirectoryAtPath(self.defaultCachePath, attributes: nil)
                    }
                    
                    var cachePath = self.getcachePath(url)
                    self.fileManager.createFileAtPath(cachePath, contents: data, attributes: nil)
                }
            }
        }
        
        // MARK: helper
        func getcachePath(url: String!) -> String! {
            var hashValue = url?.hashValue
            var key = hashValue.description
            
            return defaultCachePath.stringByAppendingPathComponent(key);
        }
    }
}