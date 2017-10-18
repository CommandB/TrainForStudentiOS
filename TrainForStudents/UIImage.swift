//
//  UIImage.swift
//  TrainForStudents
//
//  Created by 黄玮晟 on 2017/8/4.
//  Copyright © 2017年 黄玮晟. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    static func createQR(text : String , size : CGFloat) -> UIImage{
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        let ciImage = filter?.outputImage
        return createNonInterpolatedUIImageFormCIImage(image: ciImage!, size: size)
        
    }
    
    static private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        //        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        bitmapRef.draw(bitmapImage, in: extent)
        
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
    
}
