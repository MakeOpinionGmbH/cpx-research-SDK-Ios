//
//  CPXCardConfiguration.swift
//  
//
//  Created by Daniel Fredrich on 07.10.21.
//

import Foundation
import UIKit

public struct CPXCardConfiguration {
    let accentColor: UIColor
    let backgroundColor: UIColor
    let inactiveStarColor: UIColor
    let starColor: UIColor
    let textColor: UIColor
    
    public init(accentColor: UIColor,
                backgroundColor: UIColor,
                inactiveStarColor: UIColor,
                starColor: UIColor,
                textColor: UIColor) {
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.inactiveStarColor = inactiveStarColor
        self.starColor = starColor
        self.textColor = textColor
    }
}
