//
//  Extensions.swift
//  FortuneTeller2.0
//
//  Created by Hamid on 6/21/16.
//  Copyright © 2016 BlueLotus. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    var mid: CGPoint { return CGPoint(x: midX, y: midY) }
    var upperLeft: CGPoint { return CGPoint(x: minX, y: minY) }
    var lowerLeft: CGPoint { return CGPoint(x: minX, y: maxY) }
    var upperRight: CGPoint { return CGPoint(x: maxX, y: minY) }
    var lowerRight: CGPoint { return CGPoint(x: maxX, y: maxY) }
    
    init(center: CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x-size.width/2, y: center.y-size.height/2)
        self.init(origin: upperLeft, size: size)
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

extension String {
    func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
        let leadingAndTrailingWhitespacePattern = "(?:^\\s+)|(?:\\s+$)"
        do {
            let regex =  try NSRegularExpression(pattern: leadingAndTrailingWhitespacePattern, options: .caseInsensitive)
            let range = NSMakeRange(0, self.count)
            let trimmedString = regex.stringByReplacingMatches(in: self, options: .reportProgress, range: range, withTemplate: "$1")
            return trimmedString
            
        } catch let error {
            print(error)
            
        }
        
        return self
    }
}



