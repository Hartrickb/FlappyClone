//
//  RandomNumberFunction.swift
//  FlappyClone
//
//  Created by Bennett Hartrick on 9/11/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func randomNumber() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    public static func randomNumber(min min: CGFloat, max: CGFloat) -> CGFloat {
        
        return CGFloat.randomNumber() * (min - max) + min
        
    }
    
}
