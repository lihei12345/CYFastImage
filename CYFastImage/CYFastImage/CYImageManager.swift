//
//  CYImageManager.swift
//  CYFastImage
//
//  Created by jason on 14-6-20.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import Foundation
import UIkit

extension CYFastImage{
    typealias CYImageCallback = (image: UIImage!, url: String!) -> Void
    class CYImageManager {
        var infosArray: Array<DownloadInfo>
        
        init() {
            infosArray = Array<DownloadInfo>()
        }
        
        // MARK: Public methods
        
        func getImage(urlString: String!, delegate: AnyObject!, callback:CYImageCallback) {
            if urlString {
                var info = DownloadInfo(urlString: urlString, callback: callback, delegate: delegate)
                infosArray.append(info)
                
                CYFastImage.sharedImageCache.getImage(urlString){
                    [weak self]
                    (image: UIImage!, url: String!) -> Void in
                    
                    if self {
                        if image {
                            self!.docallback(image, url: url)
                        } else {
                            self!.beginDownload(url)
                        }
                    }
                }
            }
        }
        
        func cancel(delegate: AnyObject!) {
            if !delegate { return }
            
            var isDownloadCancel = false
            
            infosArray = infosArray.filter(){
                (downloadInfo: DownloadInfo) -> Bool in
                if !downloadInfo.delegate {
                    return false
                }
                
                if downloadInfo.delegate === delegate {
                    if !isDownloadCancel {
                        CYFastImage.sharedImageDownloader.cancel(downloadInfo.urlString)
                        isDownloadCancel = true
                    }
                    return false
                }
                return true
            }
        }
        
        func cancel(url: String!) {
            if !url {return}
            
            var isDownloadCancel = false
            infosArray = infosArray.filter(){
                (downloadInfo: DownloadInfo) -> Bool in
                if downloadInfo.urlString == url {
                    if !isDownloadCancel {
                        CYFastImage.sharedImageDownloader.cancel(downloadInfo.urlString)
                        isDownloadCancel = true
                    }
                    return false
                }
                return true
            }
        }
        
        // MARK: helper
        
        func docallback(image: UIImage!, url: String!){
            if !url {
                return
            }
            
            infosArray = infosArray.filter(){
                (downloadInfo: DownloadInfo) -> Bool in
                if url == downloadInfo.urlString {
                    if downloadInfo.callback {
                        downloadInfo.callback(image:image, url:url)
                    }
                    return false
                }
                return true
            }
        }
        
        func saveImage(image: UIImage!, url: String!){
            if !image || !url {
                return
            }
            
            CYFastImage.sharedImageCache.saveImage(url, image: image)
        }
        
        func beginDownload(url: String!) {
            var isDownloading = CYFastImage.sharedImageDownloader.isDownloadingImage(url)
            if !isDownloading {
                CYFastImage.sharedImageDownloader.downloadImage(url) {
                    [weak self]
                    (image: UIImage!, urlString: String!) -> Void in
                    if self {
                        self!.saveImage(image, url: urlString)
                        self!.docallback(image, url: urlString)
                    }
                }
            }
        }
        
        // MARK: DownloadInfo
        
        class DownloadInfo {
            var urlString: String!
            var callback: CYImageCallback!
            weak var delegate: AnyObject!
            
            init(urlString: String!, callback: CYImageCallback!, delegate: AnyObject!){
                self.urlString = urlString
                self.callback = callback
                self.delegate = delegate
            }
        }
        
    }
}
