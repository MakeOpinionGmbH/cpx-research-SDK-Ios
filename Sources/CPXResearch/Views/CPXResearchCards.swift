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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        CPXResearch.shared.removeCPXObserver(self)
    }
    
    public func setItems(_ items: [SurveyItem], surveyTextItem: SurveyTextItem?) {
        self.data = items
        self.textItem = surveyTextItem
        reloadData()
    }
}

extension CPXResearchCards: CPXResearchDelegate {
    public func onSurveysUpdated(new: [SurveyItem], updated: [SurveyItem], removed: [SurveyItem]) {
        setItems(CPXResearch.shared.surveys, surveyTextItem: CPXResearch.shared.surveyTextItem)
    }
    
    public func onTransactionsUpdated(unpaidTransactions: [TransactionModel]) { }
    
    public func onSurveysDidOpen() { }
    
    public func onSurveysDidClose() { }
}

extension CPXResearchCards: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data?.count ?? 0
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
        return cellType.size()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = data?[indexPath.row],
        let vc = findViewController() {
            CPXResearch.shared.openSurvey(by: data.id, on: vc)
        }
    }
}
