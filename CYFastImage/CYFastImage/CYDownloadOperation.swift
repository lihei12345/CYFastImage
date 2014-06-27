//
//  CYDownloadOperation.swift
//  CYFastImage
//
//  Created by jason on 14-6-19.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import UIKit

extension CYFastImage{
    typealias DownloadCallback = (data: NSData!, urlString: String!) -> Void
    
    class CYDownloadOperation: NSOperation , NSURLConnectionDataDelegate, NSURLConnectionDelegate{
        var urlConnection: NSURLConnection!
        var urlString: NSString!
        var data: NSMutableData?
        var finishCallback: DownloadCallback?
        var mExecuting: Bool
        var mFinished: Bool
        
        init(){
            data = NSMutableData()
            mExecuting = false
            mFinished = false
            
            super.init()
        }
        
        deinit {
            DEBUG_LOG("deinit: \(urlString)")
        }
        
        // MARK: helper
        func doneFinsh() {
            if self.executing {
                self.executing = false
            }
            
            if !self.finished {
                self.finished = true
            }
        }
        
        // MARK: NSOperation
        override func start() {
            DEBUG_LOG("start: \(urlString)")
            
            if self.cancelled {
                self.finished = true;
                return;
            }
            
            self.executing = true
            
            if NSThread.isMainThread() {
                self.main()
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.main()
                }
            }
        }
        
        override func main() {
            if let url = self.urlString {                
                var aURL: NSURL = NSURL(string: url)
                var request: NSURLRequest = NSURLRequest(URL: aURL)
                urlConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
            }
        }
        
        override func cancel() {
            DEBUG_LOG("cancel: \(urlString)")
            
            if self.finished {
                return
            }
            
            super.cancel()
            if urlConnection {
                urlConnection?.cancel()
                self.urlConnection = nil
            }
            
            self.doneFinsh()
            
            if let callback = self.finishCallback {
                callback(data: nil, urlString: urlString)
                self.data = nil
            }
        }
        
        override var executing: Bool {
        get{
            return mExecuting
        }
        set{
            self.willChangeValueForKey("isExecuting")
            mExecuting = newValue
            self.didChangeValueForKey("isExecuting")
        }
        }
        
        override var finished: Bool {
        get {
            return mFinished
        }
        set {
            self.willChangeValueForKey("isFinished")
            mFinished = newValue
            self.didChangeValueForKey("isFinished")
        }
        }
        
        override var concurrent: Bool {
            return true
        }
        
        override var asynchronous: Bool {
            return true
        }
        
        // MARK: NSURLConnection delegate
        
        func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
            self.data?.appendData(data)
        }
        
        func connectionDidFinishLoading(connection: NSURLConnection!) {
            self.urlConnection = nil
            self.doneFinsh()
            
            if let callback = self.finishCallback {
                callback(data: data, urlString: urlString)
                self.data = nil
            }
        }
        
        func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
            self.urlConnection = nil
            self.doneFinsh()
            
            if let callback = self.finishCallback {
                callback(data: nil, urlString: urlString)
                self.data = nil
            }
        }
    }
}
