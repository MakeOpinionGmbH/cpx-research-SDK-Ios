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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let amountOriginal: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 16).isActive = true
        let image = UIImage(named: "icon_clock", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        iv.image = image
        return iv
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textAlignment = .center
        return label
    }()
    
    private let ratingBar: CPXReviewBar = {
        let bar = CPXReviewBar()
        return bar
    }()

    private var bgView: UIView = UIView()
    private var cornerRadius: CGFloat = 10 {
        didSet {
            bgView.layer.cornerRadius = cornerRadius
        }
    }
    
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
        let margin: CGFloat = 4
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 4
        container.axis = .vertical
        container.alignment = .center
        
        let amountContainer = UIStackView()
        amountContainer.axis = .vertical
        amountContainer.spacing = 0

        amountContainer.addArrangedSubview(amountOriginal)
        amountContainer.addArrangedSubview(amountLabel)
        amountContainer.addArrangedSubview(currencyLabel)
        
        container.addArrangedSubview(amountContainer)
        
        let timeContainer = UIStackView()
        timeContainer.axis = .horizontal
        timeContainer.spacing = 4
        timeContainer.alignment = .center
        
        timeContainer.addArrangedSubview(timeImageView)
        timeContainer.addArrangedSubview(timeLabel)
        
        container.addArrangedSubview(timeContainer)
        container.addArrangedSubview(ratingBar)

        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .white
        bgView.addSubview(container)
        
        container.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 8).isActive = true
        container.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -8).isActive = true
        container.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: margin).isActive = true
        container.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -margin).isActive = true
        
        // corner radius
        bgView.layer.cornerRadius = cornerRadius

        // shadow
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shadowRadius = 4.0
        
        addSubview(bgView)
        bgView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
    }
}

extension CPXResearchCard: CPXResearchCardProtocol {   
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
        amountOriginal.textColor = configuration.accentColor

        if let payoutOriginal = getOriginalAmount() {
            let attributeString = NSMutableAttributedString(string: payoutOriginal)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            amountOriginal.attributedText = attributeString
            amountLabel.textColor = configuration.promotionAmountColor
        } else {
            amountOriginal.attributedText = nil
            amountLabel.textColor = configuration.accentColor
        }

        self.cornerRadius = configuration.cornerRadius
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

    private func getOriginalAmount() -> String? {
        return surveyItem?.payoutOriginal
    }
}
