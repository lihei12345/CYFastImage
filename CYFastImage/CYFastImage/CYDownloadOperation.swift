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
            mExecuting = true
            mFinished = false
            
            super.init()
        }
        
        deinit {
            DEBUG_LOG("deinit: \(urlString)")
        }
        
        func done() {
            self.executing = false
            self.finished = true
            self.data = nil
            self.urlConnection = nil
        }
        
        func cancenlURLConnection() {
            urlConnection?.cancel()
        }
        
        func internalCancel() {
            if NSThread.isMainThread() {
                self.cancenlURLConnection()
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.cancenlURLConnection()
                }
            }
            
            self.done()
            super.cancel()
        }
        
        // MARK: NSOperation
        
        override func start() {
            self.executing = true
            
            DEBUG_LOG("start: \(urlString)")
            
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
            self.internalCancel()
        }
        
        override var executing: Bool {
        get{
            return mExecuting
        }
        set{
            mExecuting = newValue
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
            if let callback = self.finishCallback {
                callback(data: data, urlString: urlString)
            }
            
            self.done()
            
            DEBUG_LOG("success: \(urlString)")
        }
        
        func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
            if let callback = self.finishCallback {
                callback(data: nil, urlString: urlString)
            }
            
            self.done()
            
            DEBUG_LOG("fail: \(urlString)")
        }
    }
}
