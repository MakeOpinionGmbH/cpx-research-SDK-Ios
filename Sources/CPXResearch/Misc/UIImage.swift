//
//  UIImage.swift
//  
//
//  Created by Daniel Fredrich on 15.02.21.
//

#if canImport(UIKit)
import UIKit
import Foundation

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor? {

        if let pixelData = cgImage?.dataProvider?.data {
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

            let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

            let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
            let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
            let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
            let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

            return UIColor(red: r, green: g, blue: b, alpha: a)
        }

        return nil
    }
}

#endif
