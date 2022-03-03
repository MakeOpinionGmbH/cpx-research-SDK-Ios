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
    let cardsOnScreen: Int
    let cornerRadius: CGFloat
    let promotionAmountColor: UIColor
    let maximumItems: Int
    let contentInsets: UIEdgeInsets

    public init(accentColor: UIColor,
                backgroundColor: UIColor,
                inactiveStarColor: UIColor,
                starColor: UIColor,
                textColor: UIColor,
                cardsOnScreen: Int,
                cornerRadius: CGFloat = 10,
                promotionAmountColor: UIColor = UIColor.systemRed,
                maximumItems: Int = Int.max,
                contentInsets: UIEdgeInsets = .zero) {
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.inactiveStarColor = inactiveStarColor
        self.starColor = starColor
        self.textColor = textColor
        self.cardsOnScreen = cardsOnScreen
        self.cornerRadius = cornerRadius
        self.promotionAmountColor = promotionAmountColor
        self.maximumItems = maximumItems
        self.contentInsets = contentInsets
    }
}
