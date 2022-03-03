//
//  CPXResearchCards.swift
//
//
//  Created by Daniel Fredrich on 29.09.21.
//

import Foundation
import UIKit

public enum CPXResearchCardType {
    case `default`
    case custom(type: CPXResearchCardProtocol.Type)
}

public class CPXResearchCards: UICollectionView {
    
    private var configuration: CPXCardConfiguration
    private var cellType: CPXResearchCardProtocol.Type = CPXResearchCard.self
    
    var data: [SurveyItem]?
    var textItem: SurveyTextItem?
    
    public init(frame: CGRect,
                collectionViewLayout layout: UICollectionViewLayout,
                configuration: CPXCardConfiguration,
                cellType: CPXResearchCardType = .default) {
        self.configuration = configuration
        super.init(frame: frame, collectionViewLayout: layout)
        
        switch cellType {
        case .default:
            register(CPXResearchCard.self, forCellWithReuseIdentifier: "cell")
            self.cellType = CPXResearchCard.self
        case .custom(let type):
            register(type, forCellWithReuseIdentifier: "cell")
            self.cellType = type
        }
        
        self.dataSource = self
        self.delegate = self
        
        CPXResearch.shared.addCPXObserver(self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onRotationDetected(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)

        contentInset = configuration.contentInsets
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        CPXResearch.shared.removeCPXObserver(self)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    
    public func setItems(_ items: [SurveyItem], surveyTextItem: SurveyTextItem?) {
        self.data = items
        self.textItem = surveyTextItem
        reloadData()
    }

    @objc
    private func onRotationDetected(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionViewLayout.invalidateLayout()
        }
    }
}

extension CPXResearchCards: CPXResearchDelegate {
    public func onSurveysUpdated(new: [SurveyItem], updated: [SurveyItem], removed: [SurveyItem]) {
        setItems(CPXResearch.shared.surveys, surveyTextItem: CPXResearch.shared.surveyTextItem)
    }
    
    public func onTransactionsUpdated(unpaidTransactions: [TransactionModel]) { }
    
    public func onSurveysDidOpen() { }
    
    public func onSurveysDidClose() { }

    public func onSurveyDidOpen() { }

    public func onSurveyDidClose() { }
}

extension CPXResearchCards: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let data = data {
                return min(data.count, configuration.maximumItems)
            }
            return 0
        default:
            return 0
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let data = data?[indexPath.row],
           let textItem = textItem,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CPXResearchCardProtocol {
            cell.setupCellWith(data,
                               surveyTextItem: textItem,
                               configuration: configuration)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let borderInset = Const.cardMargins.left + Const.cardMargins.right
        let marginPerItem = max((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0, borderInset)
        let margins = marginPerItem * CGFloat(configuration.cardsOnScreen - 1) + configuration.contentInsets.left + configuration.contentInsets.right - borderInset - Const.cardMargins.right
        let cardWidth: CGFloat = max(80, (collectionView.bounds.width - margins) / CGFloat(configuration.cardsOnScreen))
        return CGSize(width: cardWidth, height: 100)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Const.cardMargins
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = data?[indexPath.row],
        let vc = findViewController() {
            CPXResearch.shared.openSurvey(by: data.id, on: vc)
        }
    }
}
