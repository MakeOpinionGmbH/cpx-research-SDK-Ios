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
    
    func setReviewStarsTo(_ amount: Int, starColor: UIColor, inactiveStarColor: UIColor) {
        guard (0...5).contains(amount) else { fatalError("Value needs to be in range 0...5") }
        
        arrangedSubviews.forEach( { removeArrangedSubview($0) } )
        for i in 0...4 {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.heightAnchor.constraint(equalToConstant: 16).isActive = true
            iv.widthAnchor.constraint(equalToConstant: 16).isActive = true
            iv.tintColor = i < amount ? starColor : inactiveStarColor
            iv.image = image
            addArrangedSubview(iv)
        }
    }
    
    private func setupView() {
        axis = .horizontal
        spacing = 0
        alignment = .center
    }
}
