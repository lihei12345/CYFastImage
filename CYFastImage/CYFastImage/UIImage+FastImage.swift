//
//  UIImage+FastImage.swift
//  CYFastImage
//
//  Created by jason on 14-6-27.
//  Copyright (c) 2014 chenyang. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizedNewImage(newSize: CGSize) -> UIImage! {
        if newSize.width > self.size.width || newSize.height > self.size.height {
            return self
        }
        
        var hRatio = newSize.width / self.size.width
        var vRatio = newSize.height / self.size.height
        var ratio = hRatio > vRatio ? hRatio : vRatio
        var scaledSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        var newWidth = UInt(scaledSize.width)
        var newHeight = UInt(scaledSize.height)
        var bitsPerComponent = CGImageGetBitsPerComponent(self.CGImage)
        var space = CGImageGetColorSpace(self.CGImage)
        var bitmapInfo = CGImageGetBitmapInfo(self.CGImage)
        var context = CGBitmapContextCreate(nil, newWidth, newHeight, bitsPerComponent, 0, space, bitmapInfo)
        
        var rect = CGRect(origin: CGPointZero, size: scaledSize)
        CGContextDrawImage(context, rect, self.CGImage)
        var newImageRef = CGBitmapContextCreateImage(context)
        var newImage = UIImage(CGImage: newImageRef)
        CGContextRelease(context)
        
        return newImage
    }
}