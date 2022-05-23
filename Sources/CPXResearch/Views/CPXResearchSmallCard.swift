//
//  File.swift
//  
//
//  Created by Daniel Fredrich on 02.05.22.
//

import Foundation
import UIKit

final class CPXResearchSmallCard: UICollectionViewCell {
    
    private var surveyItem: SurveyItem?
    private var surveyTextItem: SurveyTextItem?
    
    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 5).isActive = true
        return view
    }()
    
    private let currencyPrefixImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
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
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let timeSeparatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.text = "|"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let ratingBar: CPXReviewBar = {
        let bar = CPXReviewBar()
        return bar
    }()
    
    private let container: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 4
        container.axis = .vertical
        container.alignment = .leading
        return container
    }()
    
    private let topContainer: UIStackView = {
        let topContainer = UIStackView()
        topContainer.spacing = 0
        topContainer.axis = .horizontal
        topContainer.alignment = .bottom
        return topContainer
    }()
    private let coloredBg: UIView = {
        let coloredBg = UIView()
        coloredBg.translatesAutoresizingMaskIntoConstraints = false
        coloredBg.clipsToBounds = true
        return coloredBg
    }()
    
    private var bgView: UIView = UIView()
    private var cornerRadius: CGFloat = 10 {
        didSet {
            bgView.layer.cornerRadius = cornerRadius
            coloredBg.layer.cornerRadius = cornerRadius
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
        amountOriginal.text = nil
        currencyLabel.text = nil
        timeLabel.text = nil
    }
    
    private func setupView() {
        topContainer.addArrangedSubview(amountOriginal)
        topContainer.addArrangedSubview(amountLabel)
        topContainer.addArrangedSubview(currencyLabel)
        
        let bottomContainer = UIStackView()
        bottomContainer.spacing = 4
        bottomContainer.axis = .horizontal
        
        bottomContainer.addArrangedSubview(timeLabel)
        bottomContainer.addArrangedSubview(timeSeparatorLabel)
        bottomContainer.addArrangedSubview(ratingBar)
        
        container.addArrangedSubview(topContainer)
        container.addArrangedSubview(bottomContainer)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .white
        
        coloredBg.addSubview(dividerView)
        dividerView.topAnchor.constraint(equalTo: coloredBg.topAnchor).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: coloredBg.bottomAnchor).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: coloredBg.leadingAnchor).isActive = true
        
        coloredBg.addSubview(container)
        
        container.leadingAnchor.constraint(equalTo: coloredBg.leadingAnchor, constant: 15).isActive = true
        container.topAnchor.constraint(equalTo: coloredBg.topAnchor, constant: 5).isActive = true
        container.bottomAnchor.constraint(equalTo: coloredBg.bottomAnchor, constant: -5).isActive = true
        container.trailingAnchor.constraint(equalTo: coloredBg.trailingAnchor, constant: -5).isActive = true
        
        bgView.addSubview(coloredBg)
        coloredBg.topAnchor.constraint(equalTo: bgView.topAnchor).isActive = true
        coloredBg.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        coloredBg.leadingAnchor.constraint(equalTo: bgView.leadingAnchor).isActive = true
        coloredBg.trailingAnchor.constraint(equalTo: bgView.trailingAnchor).isActive = true
        
        // corner radius
        bgView.layer.cornerRadius = cornerRadius
        coloredBg.layer.cornerRadius = cornerRadius
        
        // shadow
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowRadius = 4.0
        
        addSubview(bgView)
        bgView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
    }
}

extension CPXResearchSmallCard: CPXResearchCardProtocol {
    static var cellHeight: CGFloat { 45 }
    
    func setupCellWith(_ surveyItem: SurveyItem,
                       surveyTextItem: SurveyTextItem,
                       configuration: CPXCardConfiguration) {
        self.surveyItem = surveyItem
        self.surveyTextItem = surveyTextItem
        
        dividerView.backgroundColor = configuration.dividerColor
        amountLabel.textColor = configuration.accentColor
        amountOriginal.textColor = configuration.accentColor
        amountLabel.text = getAmount()
        
        if let image = configuration.currencyPrefixImage {
            topContainer.insertArrangedSubview(currencyPrefixImage, at: 0)
            currencyPrefixImage.tintColor = configuration.accentColor
            currencyPrefixImage.image = image
        } else {
            topContainer.removeArrangedSubview(currencyPrefixImage)
            currencyPrefixImage.image = nil
        }
        
        if let payoutOriginal = getOriginalAmount() {
            let attributeString = NSMutableAttributedString(string: payoutOriginal)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            amountOriginal.attributedText = attributeString
            amountLabel.textColor = configuration.promotionAmountColor
        } else {
            amountOriginal.attributedText = nil
            amountLabel.textColor = configuration.accentColor
        }
        
        currencyLabel.text = configuration.hideCurrencyName ? nil : getCurrency()
        timeLabel.text = getEstimatedTime()
        ratingBar.setReviewStarsTo(getRating(),
                                   size: 10,
                                   starColor: configuration.starColor,
                                   inactiveStarColor: configuration.inactiveStarColor,
                                   textColor: configuration.textColor,
                                   ratingAmount: configuration.hideRatingAmount ? nil : surveyItem.statisticsRatingCount)
        
        currencyLabel.textColor = configuration.accentColor
        timeLabel.textColor = configuration.textColor
        timeSeparatorLabel.textColor = configuration.textColor
        
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
