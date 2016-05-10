//
//  GGImageAttachment.swift
//  AdjustMD
//
//  Created by 宋宋 on 5/7/16.
//  Copyright © 2016 DianQK. All rights reserved.
//

import UIKit
import Kingfisher

class GGImageAttachment: NSTextAttachment {
    
    var imageURL: NSURL? {
        didSet {
            guard let imageURL = imageURL else { return }
            if let cache = ImageCache.defaultCache.retrieveImageInDiskCacheForKey(imageURL.absoluteString) {
                self.image = cache
            } else {
                ImageDownloader.defaultDownloader.downloadImageWithURL(imageURL, progressBlock: nil) { (image, error, imageURL, originalData) in
                    if let image = image, imageURL = imageURL {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.image = image
                        }
                        ImageCache.defaultCache.storeImage(image, forKey: imageURL.absoluteString)
                    }
                }
            }
        }
    }
    
    override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        
        if let image = image {
            let width = lineFrag.size.width
            let imageSize = image.size
            
            let scale = width / imageSize.width
            
            return CGRect(x: 0, y: 0, width: width, height: imageSize.height * scale)

        } else {
            return super.attachmentBoundsForTextContainer(textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        }
        
    }

}
