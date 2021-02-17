//
//  CPXConfiguration.swift
//  
//
//  Created by Daniel Fredrich on 10.02.21.
//
#if canImport(UIKit)
import UIKit
import Foundation

/// Model for the initial configuration of the CPX Research Framework.
public struct CPXConfiguration {
    /// Model for the configuration of styling aspects.
    public struct CPXStyleConfiguration {
        let position: SurveyPosition
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
        public init(position: SurveyPosition,
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
    }

    /// The position and style of the banner/notification if there are surveys available.
    public enum SurveyPosition {
        /// Banner on the side, centered vertically. Either on the left or right side of the device.
        public enum SidePosition {
            case left
            case right

            var positionString: String {
                switch self {
                case .left:
                    return "left"
                case .right:
                    return "right"
                }
            }
        }

        /// The size of the side element. Normal is 60pt, small is 30pt.
        public enum SideSize: Int {
            case normal = 60
            case small = 30
        }

        /// Overlay in a device corner. Please keep in mind that if not paid attention to it: this might be over touchable navigation elements that the user can no longer interact with.
        public enum CornerPosition {
            case topLeft
            case topRight
            case bottomLeft
            case bottomRight

            var positionString: String {
                switch self {
                case .topLeft:
                    return "topleft"
                case .topRight:
                    return "topright"
                case .bottomLeft:
                    return "bottomleft"
                case .bottomRight:
                    return "bottomright"
                }
            }
        }

        /// A notification style overlay, either on the top of the device of at the bottom.
        public enum ScreenPosition {
            case centerTop
            case centerBottom

            var positionString: String {
                switch self {
                case .centerTop:
                    return "top"
                case .centerBottom:
                    return "bottom"
                }
            }
        }

        case side(position: SidePosition, size: SideSize)
        case corner(position: CornerPosition)
        case screen(position: ScreenPosition)

        var width: Int {
            switch self {
            case .side(_, let size):
                return size.rawValue
            case .corner:
                return 160
            case .screen:
                return 320
            }
        }

        var height: Int {
            switch self {
            case .side:
                return 400
            case .corner:
                return 160
            case .screen:
                return 72
            }
        }

        var type: String {
            switch self {
            case .side:
                return "side"
            case .corner:
                return "corner"
            case .screen:
                return "screen"
            }
        }

        var positionString: String {
            switch self {
            case .side(let position, _):
                return position.positionString
            case .corner(let position):
                return position.positionString
            case .screen(let position):
                return position.positionString
            }
        }
    }

    let appId: String
    let extUserId: String
    let secureKey: String
    var style: CPXStyleConfiguration

    let email: String?
    let subid1: String?
    let subid2: String?
    let extraInfo: [String]?

    var queryItems: [URLQueryItem] {
        var result = [
            URLQueryItem(name: Const.appId, value: appId),
            URLQueryItem(name: Const.extUserId, value: extUserId),
            URLQueryItem(name: Const.type, value: String(style.position.type)),
            URLQueryItem(name: Const.position, value: style.position.positionString),
            URLQueryItem(name: Const.bannerBgColor, value: style.backgroundColor.withLeadingDot),
            URLQueryItem(name: Const.textColor, value: style.textColor.withLeadingDot),
            URLQueryItem(name: Const.roundedCorners, value: String(style.roundedCorners)),
            URLQueryItem(name: Const.width, value: String(style.position.width * Int(UIScreen.main.scale))),
            URLQueryItem(name: Const.height, value: String(style.position.height * Int(UIScreen.main.scale))),
            URLQueryItem(name: Const.emptyColor, value: nil),
            URLQueryItem(name: Const.transparent, value: "1"),
            URLQueryItem(name: Const.text, value: style.text),
            URLQueryItem(name: Const.textSize, value: String(style.textSize * Int(UIScreen.main.scale)))
        ]
        if let email = email {
            result.append(URLQueryItem(name: Const.email, value: email))
        }
        if let subid1 = subid1 {
            result.append(URLQueryItem(name: Const.subid1, value: subid1))
        }
        if let subid2 = subid2 {
            result.append(URLQueryItem(name: Const.subid2, value: subid2))
        }
        if let extra = extraInfo {
            for (index, value) in extra.enumerated() {
                result.append(URLQueryItem(name: "\(Const.extraInfo)\(index + 1)", value: value))
            }
        }

        return result
    }

    /// Initialize a new instance of the configuration.
    /// - Parameters:
    ///   - appId: The app id. Should be provided by CPX Research.
    ///   - extUserId: The ext user id.
    ///   - secureKey: A secure key for hashes. Should be provided by CPX Research.
    ///   - email: An optional email address that is sent with each request to have contact information for support questions.
    ///   - subId1: An optional sub id 1 parameter that will be send with each request (if set).
    ///   - subId2: An optional sub id 2 parameter that will be send with each request (if set).
    ///   - extraInfo: An optional (up to 10 entries) array of additional debug/support information that will be send with each request.
    ///   - style: The style configuration.
    public init(appId: String,
                extUserId: String,
                secureKey: String,
                email: String? = nil,
                subId1: String? = nil,
                subId2: String? = nil,
                extraInfo: [String]? = nil,
                style: CPXStyleConfiguration) {
        self.appId = appId
        self.extUserId = extUserId
        self.secureKey = secureKey
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
}
#endif
