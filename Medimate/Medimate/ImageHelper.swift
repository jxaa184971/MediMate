//
//  ImageHelper.swift
//  Medimate
//
//  Created by Yichuan Huang on 1/05/2016.
//  Copyright © 2016 Team MarshGhatti. All rights reserved.
//

import UIKit

class ImageHelper: NSObject {

    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
