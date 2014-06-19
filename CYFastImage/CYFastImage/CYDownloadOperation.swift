//
//  CYDownloadOperation.swift
//  CYFastImage
//
//  Created by jason on 14-6-19.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import UIKit

extension CYFastImage{
    class CYDownloadOperation: NSOperation , NSURLConnectionDataDelegate, NSURLConnectionDelegate{
        var urlConnection: NSURLConnection!
        var urlString: NSString?
        var data: NSMutableData?
        var finishCallback: (UIImage? -> Void)?
        var mExecuting: Bool
        var mFinished: Bool
        
        init(){
            data = NSMutableData()
            mExecuting = false
            mFinished = false
            
            super.init()
        }
        
        deinit {
            
        }
        
        func done() {
            self.executing = false
            self.finished = true
            self.data = nil
        }
        
        // MARK: NSOperation
        
        override func start() {
            self.executing = true
            
            if NSThread.isMainThread() {
                self.main()
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    () -> Void in
                    self.main()
                }
            }
        }
        
        override func main() {
            if let url = self.urlString {
                var aURL: NSURL = NSURL(string: url)
                var request: NSURLRequest = NSURLRequest(URL: aURL)
                urlConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
                urlConnection.start()
            }
        }
        
        override var executing: Bool {
        get{
            return mExecuting
        }
        set{
            self.willChangeValueForKey("isExecuting")
            mExecuting = newValue
            self.willChangeValueForKey("isExecuting")
        }
        }
        
        override var finished: Bool {
        get {
            return mFinished
        }
        set {
            self.willChangeValueForKey("isFinished")
            mFinished = newValue
            self.willChangeValueForKey("isFinished")
        }
        }
        
        override var concurrent: Bool {
            return true
        }
        
        // MARK: NSURLConnection delegate
        
        func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
            self.data?.appendData(data)
        }
        
        func connectionDidFinishLoading(connection: NSURLConnection!) {
            var image: UIImage = UIImage(data: self.data)
            if let callback = self.finishCallback {
                callback(image)
            }
            
            self.done()
        }
        
        func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
            if let callback = self.finishCallback {
                callback(nil)
            }
            
            self.done()
        }
    }
}
