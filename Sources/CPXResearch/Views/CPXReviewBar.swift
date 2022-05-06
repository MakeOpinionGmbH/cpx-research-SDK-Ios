//
//  CPXReviewBar.swift
//  
//
//  Created by Daniel Fredrich on 29.09.21.
//

import Foundation
import UIKit

final class CPXReviewBar: UIStackView {
    
    private let image = UIImage(named: "icon_star", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setReviewStarsTo(_ amount: Int,
                          size: CGFloat,
                          starColor: UIColor,
                          inactiveStarColor: UIColor,
                          textColor: UIColor,
                          ratingAmount: Int?) {
        guard (0...5).contains(amount) else { fatalError("Value needs to be in range 0...5") }
        
        arrangedSubviews.forEach( {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        } )
        for i in 0...4 {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.heightAnchor.constraint(equalToConstant: size).isActive = true
            iv.widthAnchor.constraint(equalToConstant: size).isActive = true
            iv.tintColor = i < amount ? starColor : inactiveStarColor
            iv.image = image
            addArrangedSubview(iv)
        }

        if let ratingAmount = ratingAmount {
            let container = UIStackView()
            container.axis = .vertical
            container.alignment = .bottom
            container.distribution = .fill

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 6)
            label.textColor = textColor
            label.text = "(\(ratingAmount))"
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            let spacer = UIView()
            spacer.backgroundColor = .clear

            container.addArrangedSubview(spacer)
            container.addArrangedSubview(label)
            addArrangedSubview(container)
        }
    }
    
    private func setupView() {
        axis = .horizontal
        spacing = 0
        alignment = .center
    }
}
