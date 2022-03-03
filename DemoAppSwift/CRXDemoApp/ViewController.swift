//
//  ViewController.swift
//  CRX Demo App
//
//  Created by Daniel Fredrich on 08.02.21.
//

import UIKit
import CPXResearch

class ViewController: UIViewController {

    private let positions: [CPXConfiguration.CPXStyleConfiguration] = [
        .init(position: .corner(position: .topLeft), text: "Coins<br> verdienen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .corner(position: .topRight), text: "Coins<br> verdienen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .corner(position: .bottomRight), text: "Coins<br> verdienen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .corner(position: .bottomLeft), text: "Coins<br> verdienen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .screen(position: .centerBottom), text: "Mehr Coins verdienen<br> durch Umfragen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .screen(position: .centerTop), text: "Mehr Coins verdienen<br> durch Umfragen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .side(position: .left, size: .normal), text: "Mehr Coins verdienen<br> durch Umfragen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .side(position: .left, size: .small), text: "Mehr Coins verdienen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .side(position: .right, size: .normal), text: "Mehr Coins verdienen<br> durch Umfragen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true),
        .init(position: .side(position: .right, size: .small), text: "Mehr Coins verdienen!", textColor: "#ffffff", backgroundColor: "#ffaf20", roundedCorners: true)
    ]
    private var bannerIndex = 0

    private var transactions = [TransactionModel]() {
        didSet {
            labelTransactions?.text = "Transactions: \(self.transactions.count)"
        }
    }
    private var surveys = [SurveyItem]()

    @IBOutlet weak var labelTransactions: UILabel?
    @IBOutlet weak var labelSurveys: UILabel?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var segControl: UISegmentedControl?
    @IBOutlet weak var cvContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CPXResearch.shared.delegate = self
        CPXResearch.shared.setSurvey(visible: true)

        tableView?.tableFooterView = UIView()
        tableView?.register(SurveyTableViewCell.self)

        tableView?.delegate = self
        tableView?.dataSource = self
        
        let cardConfiguration = CPXCardConfiguration(accentColor: UIColor(hex: "#41d7e5")!,
                                                     backgroundColor: .white,
                                                     inactiveStarColor: UIColor(hex: "#dfdfdf")!,
                                                     starColor: UIColor(hex: "#ffc400")!,
                                                     textColor: .label,
                                                     cardsOnScreen: 4)
        
        if let cards = CPXResearch.shared.getCollectionView(configuration: cardConfiguration) {
            cards.translatesAutoresizingMaskIntoConstraints = false
            cvContainer.addSubview(cards)
            cards.topAnchor.constraint(equalTo: cvContainer.topAnchor).isActive = true
            cards.bottomAnchor.constraint(equalTo: cvContainer.bottomAnchor).isActive = true
            cards.leadingAnchor.constraint(equalTo: cvContainer.leadingAnchor).isActive = true
            cards.trailingAnchor.constraint(equalTo: cvContainer.trailingAnchor).isActive = true
        }
    }

    @IBAction func onBtnTap(_ sender: Any) {
        if transactions.isEmpty {

        } else {
            let transaction = transactions.first!
            CPXResearch.shared.markTransactionAsPaid(withId: transaction.transId,
                                                     messageId: transaction.messageId)
        }
    }

    @IBAction func onStopAutoupdate(_ sender: Any) {
        CPXResearch.shared.setStyle(nextStyle())
    }

    @IBAction func onStartAutoupdate(_ sender: Any) {
        CPXResearch.shared.autoUpdateEnabled ? CPXResearch.shared.deactivateAutomaticCheckForSurveys() : CPXResearch.shared.activateAutomaticCheckForSurveys()
    }

    @IBAction func onSelectionDidChange(_ sender: Any) {
        tableView?.reloadData()
    }

    private func nextStyle() -> CPXConfiguration.CPXStyleConfiguration {
        if bannerIndex == positions.count {
            bannerIndex = 0
        }

        let style = positions[bannerIndex]
        bannerIndex += 1

        return style
    }
}

extension ViewController: CPXResearchDelegate {
    func onSurveysUpdated(new: [SurveyItem],
                          updated: [SurveyItem],
                          removed: [SurveyItem]) {
        labelSurveys?.text = "Surveys: \(CPXResearch.shared.surveys.count)"

        surveys = CPXResearch.shared.surveys
        tableView?.reloadData()
    }

    func onTransactionsUpdated(unpaidTransactions: [TransactionModel]) {
        transactions = unpaidTransactions
    }

    func onSurveysDidOpen() {
        print("Surveys did open.")
    }

    func onSurveysDidClose() {
        print("Surveys did close.")
    }

    func onSurveyDidOpen() {
        print("Survey did open.")
    }

    func onSurveyDidClose() {
        print("Survey did close.")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        segControl?.selectedSegmentIndex == 0 ? surveys.count : transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = segControl?.selectedSegmentIndex else { fatalError("No segmented control.") }

        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(type: SurveyTableViewCell.self, for: indexPath)
            let item = surveys[indexPath.row]
            cell.setup(with: item)
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(type: SurveyTableViewCell.self, for: indexPath)
            let item = transactions[indexPath.row]
            cell.setup(with: item)
            cell.accessoryType = .none
            return cell
        default:
            fatalError("Not supported index in segmented control.")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let index = segControl?.selectedSegmentIndex else { fatalError("No segmented control.") }

        switch index {
        case 0:
            let item = surveys[indexPath.row]
            CPXResearch.shared.openSurvey(by: item.id, on: self)
        case 1:
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if segControl?.selectedSegmentIndex ?? 0 == 1 {
            let action = UIContextualAction(style: .normal,
                                            title: "Mark as paid") { [weak self] (action, view, completionHandler) in
                if let item = self?.transactions[indexPath.row] {
                    CPXResearch.shared.markTransactionAsPaid(withId: item.transId,
                                                             messageId: item.messageId)
                }
            }
            action.backgroundColor = .systemBlue

            return UISwipeActionsConfiguration(actions: [action])
        }

        return nil
    }
}
