//
//  SurveyTableViewCell.swift
//  CRX Demo App
//
//  Created by Daniel Fredrich on 11.02.21.
//

import UIKit
import CPXResearch

class SurveyTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel?
    @IBOutlet weak var labelSubtitle: UILabel?
    @IBOutlet weak var labelStats: UILabel?
    @IBOutlet weak var labelContent: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        labelTitle?.text = nil
        labelSubtitle?.text = nil
        labelStats?.text = nil
        labelContent?.text = nil
    }

    func setup(with item: SurveyItem) {
        labelTitle?.text = "ID: \(item.id)"
        labelSubtitle?.text = "\(item.payout)"
        labelStats?.text = "\(item.statisticsRatingAvg) stars by \(item.statisticsRatingCount) ratings"
        labelContent?.text = """
            Loi: \(item.loi)
            ConversionRate: \(item.conversionRate)
            Type: \(item.type)
            Top: \(item.top)
            Details: \(item.details ?? -1)
            EarnedAll: \(item.earnedAll ?? -1)
            Parameters: \(item.additionalParameter ?? [String: String]())
            """
    }

    func setup(with item: TransactionModel) {
        labelTitle?.text = "TransactionId: \(item.transId)"
        labelSubtitle?.text = "Verdienst Publisher: \(item.verdienstPublisher)"
        labelStats?.text = "Verdienst User: \(item.verdienstUserLocalMoney)"
        labelContent?.text = """
            MessageId: \(item.messageId)
            Type: \(item.type)
            SubId1: \(item.subId1)
            SubId2: \(item.subId2)
            DateTime: \(item.dateTime)
            Status: \(item.status)
            SurveyId: \(item.surveyId)
            IP: \(item.ipAddr)
            Loi: \(item.loi)
            PaidToUser: \(item.isPaidToUser)
            PaidToUserDateTime: \(item.isPaidToUserDateTime)
            PaidToUserType: \(item.isPaidToUser)
            """
    }
}
