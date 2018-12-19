//
//  Color+MovieFinder.swift
//  MovieFinder
//
//  Created by Alexandr Nadtoka on 11/19/18.
//  Copyright © 2018 kreatimont. All rights reserved.
//

import UIKit

struct Color {
    
    static let background = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
    static let cellBackground = UIColor(hexString: "#191919")
    static let destructive = UIColor(hexString: "#cf2929")
    static let mainText = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
    static let secondaryText = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
    static let separator = UIColor(hexString: "#4f4f4f")
    
}

extension UIColor {
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

