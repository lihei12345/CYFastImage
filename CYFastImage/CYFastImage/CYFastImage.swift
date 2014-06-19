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
    typealias CYImageCallback = (image: UIImage!) -> Void
    
    static var sharedImageDownloader = CYImageDownloader()
    static var sharedImageManager = CYImageManager()
    
    struct DownloadInfo {
        weak var delegate: AnyObject!
        var urlString: String!
        var callback: CYImageCallback
    }
    
    class CYImageManager {
        var infosArray: DownloadInfo[]
        
        init() {
            infosArray = DownloadInfo[]()
        }
        
        func getImage(urlString: String!, delegate: AnyObject!, callback:CYImageCallback) {
            
        }
        
        func cancel(delegate: AnyObject!) {
            
        }
        
        var downloadCallback: DownloadCallback = {
            (image: UIImage!, urlString: String!) -> Void in
            
        }
    }
}