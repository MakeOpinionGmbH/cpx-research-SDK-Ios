//
//  File.swift
//  
//
//  Created by Daniel Fredrich on 16.02.21.
//

#if canImport(UIKit)
import UIKit
import Foundation

/// Model for the initial configuration of the CPX Research Framework.
@objc
public final class CPXLegacyConfiguration: NSObject {

    let appId: String
    let extUserId: String
    let secureHash: String
    let style: CPXLegacyStyleConfiguration

    let email: String?
    let subid1: String?
    let subid2: String?
    let extraInfo: [String]?

    /// Initialize a new instance of the configuration.
    /// - Parameters:
    ///   - appId: The app id. Should be provided by CPX Research.
    ///   - extUserId: The ext user id.
    ///   - secureHash: A secure hash. Should be provided by CPX Research.
    ///   - email: An optional email address that is sent with each request to have contact information for support questions.
    ///   - subId1: An optional sub id 1 parameter that will be send with each request (if set).
    ///   - subId2: An optional sub id 2 parameter that will be send with each request (if set).
    ///   - extraInfo: An optional (up to 10 entries) array of additional debug/support information that will be send with each request.
    ///   - style: The style configuration.
    @objc
    public init(appId: String,
                extUserId: String,
                secureHash: String,
                email: String? = nil,
                subId1: String? = nil,
                subId2: String? = nil,
                extraInfo: [String]? = nil,
                style: CPXLegacyStyleConfiguration) {
        self.appId = appId
        self.extUserId = extUserId
        self.secureHash = secureHash
        self.style = style
        self.email = email
        self.subid1 = subId1
        self.subid2 = subId2
        if let extra = extraInfo {
            self.extraInfo = Array(extra.prefix(upTo: 10))
        } else {
            self.extraInfo = nil
        }
    }

    func asStruct() -> CPXConfiguration {
        CPXConfiguration(appId: appId,
                         extUserId: extUserId,
                         secureHash: secureHash,
                         email: email,
                         subId1: subid1,
                         subId2: subid2,
                         extraInfo: extraInfo,
                         style: style.asStruct())
    }
}

@objc
public final class CPXLegacyStyleConfiguration: NSObject {

    @objc public enum LegacySurveyPosition: Int {
        case sideLeftNormal
        case sideLeftSmall
        case sideRightNormal
        case sideRightSmall
        case cornerTopLeft
        case cornerTopRight
        case cornerBottomRight
        case cornerBottomLeft
        case screenCenterTop
        case screenCenterBottom
    }

    let position: LegacySurveyPosition
    let text: String
    let textSize: Int
    let textColor: String
    let backgroundColor: String
    let roundedCorners: Bool

    /// Initialize a new instance of the style configuration.
    /// - Parameters:
    ///   - position: The position and type of the banner/notification.
    ///   - text: The text that should be displayed on the banner/notification. Linebreaks can be forced using `<br>`
    ///   - textSize: The size of the text in pt. Defaults to `20`. Will automatically calculated to px according to device's scale when using it in image requests.
    ///   - textColor: The color for text as hex-color string. Can start with #. Can be 6 or 8 digits long.
    ///   - backgroundColor: The color for the banner's/notification's background. Can start with #. Can be 6 or 8 digits long.
    ///   - roundedCorners: Sets if corners should be rounded or not.
    @objc
    public init(position: LegacySurveyPosition,
                text: String,
                textSize: Int = 20,
                textColor: String,
                backgroundColor: String,
                roundedCorners: Bool) {
        self.position = position
        self.text = text
        self.textSize = textSize
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.roundedCorners = roundedCorners
    }

    func asStruct() -> CPXConfiguration.CPXStyleConfiguration {
        CPXConfiguration.CPXStyleConfiguration(position: enumToSwiftEnum(position),
                                               text: text,
                                               textColor: textColor,
                                               backgroundColor: backgroundColor,
                                               roundedCorners: roundedCorners)
    }

    private func enumToSwiftEnum(_ objc: LegacySurveyPosition) -> CPXConfiguration.SurveyPosition {
        switch objc {
        case .sideLeftNormal:
            return .side(position: .left, size: .normal)
        case .sideLeftSmall:
            return .side(position: .left, size: .small)
        case .sideRightNormal:
            return .side(position: .right, size: .normal)
        case .sideRightSmall:
            return .side(position: .right, size: .small)
        case .cornerTopLeft:
            return .corner(position: .topLeft)
        case .cornerTopRight:
            return .corner(position: .topRight)
        case .cornerBottomRight:
            return .corner(position: .bottomRight)
        case .cornerBottomLeft:
            return .corner(position: .bottomLeft)
        case .screenCenterTop:
            return .screen(position: .centerTop)
        case .screenCenterBottom:
            return .screen(position: .centerBottom)
        }
    }
}
#endif
