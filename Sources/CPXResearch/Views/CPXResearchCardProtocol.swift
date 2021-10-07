//
//  CPXResearchCardProtocol.swift
//  
//
//  Created by Daniel Fredrich on 29.09.21.
//

import Foundation
import UIKit

public protocol CPXResearchCardProtocol where Self: UICollectionViewCell {
    func setupCellWith(_ surveyItem: SurveyItem,
                       surveyTextItem: SurveyTextItem,
                       configuration: CPXCardConfiguration)
    static func size() -> CGSize
}
