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
    typealias CacheCallback = (data: NSData!, url: String!) -> Void
    
    class CYImageCache: NSObject {
        var cacheQueue: dispatch_queue_t!
        var defaultCachePath: String
        var fileManager: NSFileManager
        var maxDiskCacheDuration: NSTimeInterval
        
        init() {
            cacheQueue = dispatch_queue_create("cyfastimage_cache_queue", nil)
            var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            defaultCachePath = paths[0] as NSString
            defaultCachePath = defaultCachePath.stringByAppendingPathComponent("com.chenyang.imagecache");
            
            fileManager = NSFileManager()
            
            // disk cache for one week
            maxDiskCacheDuration = 7*12*60*60
            
            super.init()
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "recycleDisk",
                name: UIApplicationDidEnterBackgroundNotification,
                object: nil)
        }
        
        deinit {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        // MARK: public
        func getData(url: String!, callback:CacheCallback!) {
            if !url || !callback {
                return
            }
            
            var cachepath = getcachePath(url)
            if !self.fileManager.fileExistsAtPath(cachepath) {
                callback(data: nil, url: url)
            } else {
                var data = NSData(contentsOfFile: cachepath)
                callback(data: data, url: url)
            }
        }
        
        func saveImage(url: String!, data: NSData!) {
            if !url {
                return
            }
            
            if data {
                dispatch_async(cacheQueue){
                    var isExist = self.fileManager.fileExistsAtPath(self.defaultCachePath)
                    
                    if !isExist {
                        self.fileManager.removeItemAtPath(self.defaultCachePath, error: nil)
                        self.fileManager.createDirectoryAtPath(self.defaultCachePath, attributes: nil)
                    }
                    
                    var cachePath = self.getcachePath(url)
                    self.fileManager.createFileAtPath(cachePath, contents: data, attributes: nil)
                    if !self.fileManager.fileExistsAtPath(cachePath) {
                        NSLog(cachePath)
                    }
                }
            }
        }
        
        func clearDisk() {
            dispatch_async(cacheQueue) {
                if self.fileManager.fileExistsAtPath(self.defaultCachePath) {
                    self.fileManager.removeItemAtPath(self.defaultCachePath, error: nil)
                    self.fileManager.createDirectoryAtPath(self.defaultCachePath, attributes: nil)
                }
            }
        }
        
        func recycleDisk() {
            dispatch_async(cacheQueue) {
                var array = self.fileManager.contentsOfDirectoryAtPath(self.defaultCachePath, error: nil)
                
                var resourceKeys : String[] = [NSURLIsDirectoryKey, NSURLAttributeModificationDateKey]
                var expireDate: NSDate = NSDate(timeIntervalSinceNow: -self.maxDiskCacheDuration)
                var fileToRemove = String[]()
                
                for item : AnyObject in array {
                    if let fileName = item as? NSString {
                        var path = self.defaultCachePath.stringByAppendingPathComponent(fileName)
                        var url = NSURL(fileURLWithPath: path)
                        var value = url.resourceValuesForKeys(resourceKeys, error: nil)
                        if let isDir = value[NSURLIsDirectoryKey].boolValue {
                            if isDir {
                                continue
                            }
                        }
                        
                        if let latestModifDate = value[NSURLAttributeModificationDateKey] as? NSDate {
                            if latestModifDate.timeIntervalSince1970 - expireDate.timeIntervalSince1970 <= 0 {
                                fileToRemove.append(path)
                            }
                        }
                    }
                }
                
                for url in fileToRemove {
                    self.fileManager.removeItemAtPath(url, error: nil)
                }
            }
        }
        
        // MARK: helper
        func getcachePath(url: String!) -> String! {
            var hashValue = url?.hashValue
            var key = hashValue.description
            var cacheFilePath = defaultCachePath.stringByAppendingPathComponent(key)
            return cacheFilePath
        }
    }
}