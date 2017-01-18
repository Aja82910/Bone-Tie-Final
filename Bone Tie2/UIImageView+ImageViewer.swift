//
//  UIImageView+ImageViewer.swift
//  ImageViewer
//
//  Created by Tan Nghia La on 03.05.15.
//  Copyright (c) 2015 Tan Nghia La. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    public func setupForImageViewer(_ highQualityImageUrl: URL? = nil, backgroundColor: UIColor = UIColor.white) {
        isUserInteractionEnabled = true
        let gestureRecognizer = ImageViewerTapGestureRecognizer(target: self, action: #selector(UIImageView.didTap(_:)), highQualityImageUrl: highQualityImageUrl, backgroundColor: backgroundColor)
        addGestureRecognizer(gestureRecognizer)
    }
    
    internal func didTap(_ recognizer: ImageViewerTapGestureRecognizer) {        
        let imageViewer = ImageViewer(senderView: self, highQualityImageUrl: recognizer.highQualityImageUrl, backgroundColor: recognizer.backgroundColor)
        imageViewer.presentFromRootViewController()
    }
}

class ImageViewerTapGestureRecognizer: UITapGestureRecognizer {
    var highQualityImageUrl: URL?
    var backgroundColor: UIColor!
    
    init(target: AnyObject, action: Selector, highQualityImageUrl: URL?, backgroundColor: UIColor) {
        self.highQualityImageUrl = highQualityImageUrl
        self.backgroundColor = backgroundColor
        super.init(target: target, action: action)
    }
}
