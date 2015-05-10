//
//  UIColorExtension.swift
//  SuggestedSeller
//
//  Created by KeyongZhangon 9/11/14.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
   class func colorWithHexValue(hexValue:NSString) -> UIColor {
        
        var c:UInt32 = 0xffffff
        
        if hexValue.hasPrefix("#") {
            NSScanner(string: hexValue.substringFromIndex(1)).scanHexInt(&c)
        }else{
            NSScanner(string: hexValue).scanHexInt(&c)
        }
        
        if hexValue.length > 7 {
            return UIColor(red: CGFloat((c & 0xff000000) >> 24)/255.0, green: CGFloat((c & 0xff0000) >> 16)/255.0, blue: CGFloat((c & 0xff00) >> 8)/255.0, alpha: CGFloat(c & 0xff)/255.0)
        }else{
            return UIColor(red: CGFloat((c & 0xff0000) >> 16)/255.0, green: CGFloat((c & 0xff00) >> 8)/255.0, blue: CGFloat(c & 0xff)/255.0, alpha: 1.0)
        }
    }
    
    class func lightBlueCustom() -> UIColor {
        return UIColor.colorWithHexValue("#4CBCE8")
    }
    
    class func fuchsiaColor() -> UIColor {
        return UIColor.colorWithHexValue("#BD225C")
    }
    
    class func fuchsiaHighlightedColor() -> UIColor {
        return UIColor.colorWithHexValue("#A00945")
    }
    class func yellow1Color() -> UIColor {
        return UIColor.colorWithHexValue("#F8DD95")
    }
    
    class func yellow2Color() -> UIColor {
        return UIColor.colorWithHexValue("#FFEFC6")
    }
    
    class func green1Color() -> UIColor {
        return UIColor.colorWithHexValue("#7B8141")
    }
    
    class func green2Color() -> UIColor {
        return UIColor.colorWithHexValue("#99A549")
    }
    
    class func green3Color() -> UIColor {
        return UIColor.colorWithHexValue("#CED9B1")
    }
    
    class func green4Color() -> UIColor {
        return UIColor.colorWithHexValue("#E7E9D8")
    }
    
    class func blackColor() -> UIColor {
        return UIColor.colorWithHexValue("#000000")
    }
    
    class func grey1Color() -> UIColor {
        return UIColor.colorWithHexValue("#53585F")
    }
    
    class func grey2Color() -> UIColor {
        return UIColor.colorWithHexValue("#A5A5A5")
    }
    
    class func grey3Color() -> UIColor {
        return UIColor.colorWithHexValue("#DDDDDD")
    }
    
    class func whiteColor() -> UIColor {
        return UIColor.colorWithHexValue("#FFFFFF")
    }
}
