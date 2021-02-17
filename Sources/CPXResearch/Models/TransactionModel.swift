//
//  TransactionModel.swift
//  
//
//  Created by Daniel Fredrich on 08.02.21.
//

import Foundation

/// Model containing information about a transaction.
@objc
public final class TransactionModel: NSObject, Codable, Identifiable {

    /// The transaction id for this transaction. Required to mark it as paid to the user later.
    public var id: String { transId }

    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case type
        case transId = "trans_id"
        case verdienstPublisher = "verdienst_publisher"
        case verdienstUserLocalMoney = "verdienst_user_local_money"
        case subId1 = "subid_1"
        case subId2 = "subid_2"
        case dateTime = "datetime"
        case status
        case surveyId = "survey_id"
        case ipAddr = "ip"
        case loi
        case isPaidToUser = "is_paid_to_user"
        case isPaidToUserDateTime = "is_paid_to_user_datetime"
        case IsPaidToUserType = "is_paid_to_user_type"
    }


    /// The message id for this transaction. Required to mark it as paid to the user later.
    @objc public let messageId: String
    /// The type of this transaction.
    @objc public let type: String
    /// The transaction id for this transaction. Required to mark it as paid to the user later.
    @objc public let transId: String
    @objc public let verdienstPublisher: String
    @objc public let verdienstUserLocalMoney: String
    @objc public let subId1: String
    @objc public let subId2: String
    @objc public let dateTime: String
    /// The current status of the transaction.
    @objc public let status: String
    /// The survey id of the survey that was done for this transaction.
    @objc public let surveyId: String
    @objc public let ipAddr: String
    @objc public let loi: String
    @objc public let isPaidToUser: String
    @objc public let isPaidToUserDateTime: String
    @objc public let IsPaidToUserType: String
}
