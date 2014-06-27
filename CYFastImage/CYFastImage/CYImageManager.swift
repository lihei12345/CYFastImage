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
        var downloadingUrlDic: Dictionary<String, Int>
        
        init() {
            infosArray = Array<DownloadInfo>()
            downloadingUrlDic = Dictionary<String, Int>()
        }
        
        // MARK: Public
        func getImage(urlString: String!, delegate: AnyObject!, callback:CYImageCallback) {
            if urlString {
                var info = DownloadInfo(urlString: urlString, callback: callback, delegate: delegate, preferredSize: CGSizeZero)
                infosArray.append(info)

                CYFastImage.sharedImageCache.getData(urlString){
                    (data: NSData!, url: String!) -> Void in
                    if data {
                        self.docallback(data, url: url)
                    } else {
                        self.beginDownload(url)
                    }
                }
            }
        }
        
        func cancel(delegate: AnyObject!) {
            if !delegate { return }
            
            var shouldCancelDownload = false
            var infosNeedToRemove = Int[]()
            
            var i:Int = 0;
            for downloadInfo: DownloadInfo in infosArray {
                i = i + 1
                if !downloadInfo.delegate {
                    continue
                }
                if downloadInfo.delegate === delegate {
                    infosNeedToRemove.append(i)
                }
            }
            
            // remove callbacks
            for index: Int in infosNeedToRemove {
                var info = infosArray[index - 1]
                var num: Int? = downloadingUrlDic[info.urlString]
                if let number = num {
                    if number <= 1 {
                        // cancel image downloading
                        CYFastImage.sharedImageDownloader.cancel(info.urlString)
                    } else {
                        downloadingUrlDic[info.urlString] = number - 1
                    }
                }
                infosArray.removeAtIndex(index - 1)
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
        func docallback(data: NSData!, url: String!){
            if !url {
                return
            }
            
            infosArray = infosArray.filter(){
                (downloadInfo: DownloadInfo) -> Bool in
                if url == downloadInfo.urlString {
                    if downloadInfo.callback {
                        var image = UIImage(data: data)
                        downloadInfo.callback(image:image, url:url)
                    }
                    return false
                }
                return true
            }
        }
        
        func saveImage(data: NSData!, url: String!){
            if !data || !url {
                return
            }
            
            CYFastImage.sharedImageCache.saveImage(url, data: data)
        }
        
        func beginDownload(url: String!) {
            var numberOfDownloading:Int? = downloadingUrlDic[url]
            if let number = numberOfDownloading {
                if number >= 1 {
                    downloadingUrlDic[url] = number + 1
                    return
                }
            }
            
            downloadingUrlDic[url] = 1
            
            CYFastImage.sharedImageDownloader.downloadImage(url) {
                (data: NSData!, urlString: String!) -> Void in
                self.downloadingUrlDic.removeValueForKey(url)
                self.saveImage(data, url: urlString)
                self.docallback(data, url: urlString)
            }
        }
        
        // MARK: DownloadInfo
        class DownloadInfo {
            var urlString: String!
            var callback: CYImageCallback!
            weak var delegate: AnyObject!
            var preferredSize: CGSize
            
            init(urlString: String!, callback: CYImageCallback!, delegate: AnyObject!, preferredSize: CGSize){
                self.urlString = urlString
                self.callback = callback
                self.delegate = delegate
                self.preferredSize = preferredSize
            }
        }
        
    }
}
