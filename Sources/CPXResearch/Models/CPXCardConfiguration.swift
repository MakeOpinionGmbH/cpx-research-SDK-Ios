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
    let dividerColor: UIColor

    let cardsOnScreen: Int
    let cornerRadius: CGFloat
    let promotionAmountColor: UIColor
    let maximumItems: Int

    let contentInsets: UIEdgeInsets

    let cardStyle: CPXResearchCardType
    let currencyPrefixImage: UIImage?

    let fixedWidth: Int

    let hideCurrencyName: Bool
    let hideRatingAmount: Bool

    public static var Builder = CPXCardConfigurationBuilder()
}

public final class CPXCardConfigurationBuilder {
    private var _accentColor = UIColor(hex: "#41d7e5")!
    private var _backgroundColor = UIColor.white
    private var _inactiveStarColor = UIColor(hex: "#dfdfdf")!
    private var _starColor = UIColor(hex: "#ffaa00")!
    private var _textColor = UIColor.gray
    private var _dividerColor = UIColor(hex: "#5A7DFE")!
    private var _promotionAmountColor = UIColor.systemRed

    private var _cardsOnScreen: Int = 3
    private var _cornerRadius: CGFloat = 10
    private var _maximumItems: Int = Int.max

    private var _contentInsets: UIEdgeInsets = .zero

    private var _cpxCardStyle = CPXResearchCardType.default
    private var _currencyPrefixImage: UIImage? = nil

    private var _fixedWidth: Int = 0

    private var _hideCurrencyName = false
    private var _hideRatingAmount = true

    public func accentColor(_ color: UIColor) -> CPXCardConfigurationBuilder {
        _accentColor = color
        return self
    }

    public func backgroundColor(_ color: UIColor) -> CPXCardConfigurationBuilder {
        _backgroundColor = color
        return self
    }

    public func starColor(_ color: UIColor) -> CPXCardConfigurationBuilder {
        _starColor = color
        return self
    }

    public func inactiveStarColor(_ color: UIColor) -> CPXCardConfigurationBuilder {
        _inactiveStarColor = color
        return self
    }

    public func textColor(_ color: UIColor) -> CPXCardConfigurationBuilder {
        _textColor = color
        return self
    }

    public func dividerColor(_ color: UIColor) -> CPXCardConfigurationBuilder {
        _dividerColor = color
        return self
    }

    public func promotionAmountColor(_ color: UIColor) -> CPXCardConfigurationBuilder {
        _promotionAmountColor = color
        return self
    }

    public func cardsOnScreen(_ amount: Int) -> CPXCardConfigurationBuilder {
        _cardsOnScreen = amount
        return self
    }

    public func cornderRadius(_ radius: CGFloat) -> CPXCardConfigurationBuilder {
        _cornerRadius = radius
        return self
    }

    public func maximumSurveys(_ amount: Int) -> CPXCardConfigurationBuilder {
        _maximumItems = amount
        return self
    }

    public func padding(_ insets: UIEdgeInsets) -> CPXCardConfigurationBuilder {
        _contentInsets = insets
        return self
    }

    public func cpxCardStyle(_ style: CPXResearchCardType) -> CPXCardConfigurationBuilder {
        _cpxCardStyle = style
        return self
    }

    public func currencyPrefixImage(_ image: UIImage?) -> CPXCardConfigurationBuilder {
        _currencyPrefixImage = image
        return self
    }

    public func fixedCPXCardWidth(_ width: Int) -> CPXCardConfigurationBuilder {
        _fixedWidth = width
        return self
    }

    public func hideCurrencyName(_ bool: Bool) -> CPXCardConfigurationBuilder {
        _hideCurrencyName = bool
        return self
    }

    public func hideRatingAmount(_ bool: Bool) -> CPXCardConfigurationBuilder {
        _hideRatingAmount = bool
        return self
    }

    public func build() -> CPXCardConfiguration {
        CPXCardConfiguration(accentColor: _accentColor,
                             backgroundColor: _backgroundColor,
                             inactiveStarColor: _inactiveStarColor,
                             starColor: _starColor,
                             textColor: _textColor,
                             dividerColor: _dividerColor,
                             cardsOnScreen: _cardsOnScreen,
                             cornerRadius: _cornerRadius,
                             promotionAmountColor: _promotionAmountColor,
                             maximumItems: _maximumItems,
                             contentInsets: _contentInsets,
                             cardStyle: _cpxCardStyle,
                             currencyPrefixImage: _currencyPrefixImage,
                             fixedWidth: _fixedWidth,
                             hideCurrencyName: _hideCurrencyName,
                             hideRatingAmount: _hideRatingAmount)
    }
}
