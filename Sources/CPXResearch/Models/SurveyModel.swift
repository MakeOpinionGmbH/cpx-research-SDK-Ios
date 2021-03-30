//
//  SurveyModel.swift
//  
//
//  Created by Daniel Fredrich on 08.02.21.
//

import Foundation

struct SurveyModel: Codable {
    enum CodingKeys: String, CodingKey {
        case status
        case availableSurveysCount = "count_available_surveys"
        case returnedSurveysCount = "count_returned_surveys"
        case transactions
        case surveys
        case text
    }

    let status: String
    let availableSurveysCount: Int
    let returnedSurveysCount: Int
    let transactions: [TransactionModel]?
    let surveys: [SurveyItem]
    let text: SurveyTextItem
}

public struct SurveyTextItem: Codable {
    enum CodingKeys: String, CodingKey {
        case isHtml = "is_html"
        case currencyNamePlural = "currency_name_plural"
        case currencyNameSingular = "currency_name_singular"
        case shortcurtMin = "shortcurt_min"
        case headlineGeneral = "headline_general"
        case headline1Element1 = "headline_1_element_1"
        case headline2Element1 = "headline_2_element_1"
        case headline1Element2 = "headline_1_element_2"
        case reload1ShortText = "reload_1_short_text"
        case reload1ShortTime = "reload_1_short_time"
        case reload2ShortText = "reload_2_short_text"
        case reload2ShortTime = "reload_2_short_time"
        case reload3ShortText = "reload_3_short_text"
        case reload3ShortTime = "reload_3_short_time"
    }

    public let isHtml: Bool?
    public let currencyNamePlural: String
    public let currencyNameSingular: String
    public let shortcurtMin: String
    public let headlineGeneral: String
    public let headline1Element1: String
    public let headline2Element1: String
    public let headline1Element2: String
    public let reload1ShortText: String
    public let reload1ShortTime: Int
    public let reload2ShortText: String
    public let reload2ShortTime: Int
    public let reload3ShortText: String
    public let reload3ShortTime: Int
}

/// Model of a survey.
@objc
public final class SurveyItem: NSObject, Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id
        case loi
        case payout
        case conversionRate = "conversion_rate"
        case statisticsRatingCount = "statistics_rating_count"
        case isTestSurvey = "istestsurvey"
        case statisticsRatingAvg = "statistics_rating_avg"
        case type
        case top
        case details
        case earnedAll = "earned_all"
        case additionalParameter = "additional_parameter"
    }

    /// The id of the survey.
    @objc public let id: String
    @objc public let loi: Int
    @objc public let payout: String
    @objc public let conversionRate: String
    public let isTestSurvey: Int?
    @objc public let statisticsRatingCount: Int
    @objc public let statisticsRatingAvg: Int
    @objc public let type: String
    @objc public let top: Int
    public let details: Int?
    public let earnedAll: Int?
    @objc public let additionalParameter: Dictionary<String, String>?

    public static func ==(lhs: SurveyItem, rhs: SurveyItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.loi == rhs.loi &&
            lhs.payout == rhs.payout &&
            lhs.conversionRate == rhs.conversionRate &&
            lhs.isTestSurvey == lhs.isTestSurvey &&
            lhs.statisticsRatingCount == rhs.statisticsRatingCount &&
            lhs.statisticsRatingAvg == rhs.statisticsRatingAvg &&
            lhs.type == rhs.type &&
            lhs.top == rhs.top &&
            lhs.details == rhs.details &&
            lhs.earnedAll == rhs.earnedAll
    }
}
