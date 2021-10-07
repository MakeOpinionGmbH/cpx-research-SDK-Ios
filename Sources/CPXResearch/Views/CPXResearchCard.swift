//
//  CPXResearchCard.swift
//  
//
//  Created by Daniel Fredrich on 29.09.21.
//

import Foundation
import UIKit

final class CPXResearchCard: UICollectionViewCell {
    
    private var surveyItem: SurveyItem?
    private var surveyTextItem: SurveyTextItem?
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3).bold()
        label.textAlignment = .center
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body).bold()
        label.textAlignment = .center
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        let image = UIImage(named: "icon_clock", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        return iv
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body).bold()
        label.textAlignment = .center
        return label
    }()
    
    private let ratingBar: CPXReviewBar = {
        let bar = CPXReviewBar()
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("Not supported.")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        amountLabel.text = nil
        currencyLabel.text = nil
        timeLabel.text = nil
    }
    
    private func setupView() {
        let margin: CGFloat = 8
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 12
        container.axis = .vertical
        container.alignment = .center
        
        let amountContainer = UIStackView()
        amountContainer.axis = .vertical
        
        amountContainer.addArrangedSubview(amountLabel)
        amountContainer.addArrangedSubview(currencyLabel)
        
        container.addArrangedSubview(amountContainer)
        
        let timeContainer = UIStackView()
        timeContainer.axis = .horizontal
        timeContainer.spacing = 8
        timeContainer.alignment = .center
        
        timeContainer.addArrangedSubview(timeImageView)
        timeContainer.addArrangedSubview(timeLabel)
        
        container.addArrangedSubview(timeContainer)
        container.addArrangedSubview(ratingBar)

        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = .white
        bg.addSubview(container)
        
        container.topAnchor.constraint(equalTo: bg.topAnchor, constant: margin).isActive = true
        container.bottomAnchor.constraint(equalTo: bg.bottomAnchor, constant: -margin).isActive = true
        container.leadingAnchor.constraint(equalTo: bg.leadingAnchor, constant: margin).isActive = true
        container.trailingAnchor.constraint(equalTo: bg.trailingAnchor, constant: -margin).isActive = true
        
        // corner radius
        bg.layer.cornerRadius = 10

        // shadow
        bg.layer.shadowColor = UIColor.black.cgColor
        bg.layer.shadowOffset = CGSize(width: 0, height: 1)
        bg.layer.shadowOpacity = 0.4
        bg.layer.shadowRadius = 4.0
        
        addSubview(bg)
        bg.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        bg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        bg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        bg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
    }
}

extension CPXResearchCard: CPXResearchCardProtocol {
    static func size() -> CGSize {
        CGSize(width: 160, height: 160)
    }
    
    func setupCellWith(_ surveyItem: SurveyItem,
                       surveyTextItem: SurveyTextItem,
                       configuration: CPXCardConfiguration) {
        self.surveyItem = surveyItem
        self.surveyTextItem = surveyTextItem
        
        amountLabel.text = getAmount()
        currencyLabel.text = getCurrency()
        timeLabel.text = getEstimatedTime()
        ratingBar.setReviewStarsTo(getRating(),
                                   starColor: configuration.starColor,
                                   inactiveStarColor: configuration.inactiveStarColor)
        
        timeImageView.tintColor = configuration.accentColor
        amountLabel.textColor = configuration.accentColor
        currencyLabel.textColor = configuration.accentColor
        timeLabel.textColor = configuration.textColor
    }
    
    private func getAmount() -> String {
        guard let surveyItem = surveyItem else { return "" }
        
        return surveyItem.payout
    }
    
    private func getCurrency() -> String {
        guard let surveyTextItem = surveyTextItem else { return "" }
        
        return surveyTextItem.currencyNamePlural
    }
    
    private func getEstimatedTime() -> String {
        guard let surveyItem = surveyItem,
              let surveyTextItem = surveyTextItem else { return "" }
        
        return "\(surveyItem.loi) \(surveyTextItem.shortcurtMin)"
    }
    
    private func getRating() -> Int {
        guard let surveyItem = surveyItem else { return 0 }
        
        return surveyItem.statisticsRatingAvg
    }
}
