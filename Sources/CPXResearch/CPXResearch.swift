//
//  CPXResearch.swift
//
//
//  Created by Daniel Fredrich on 08.02.21.
//

#if canImport(UIKit)
import Foundation
import UIKit
import WebKit

@objc
final public class CPXResearch: NSObject {
    @objc public static var shared = CPXResearch()
    private static var configuration: CPXConfiguration?

    private var api = NetworkService()
    private var bannerView: CPXBannerView?
    private var webView: CPXWebView?
    private var shouldShowBannerIfAvailable = false {
        didSet {
            shouldShowBannerIfAvailable ? installBanner() : removeBanner()
        }
    }
    private var surveyModel: SurveyModel?
    private weak var webViewController: UIViewController?
    private var timer: Timer?

    /// Delegate to get information about CPX Research events regarding, opening/closing views, new surveys and/or transactions.
    @objc public weak var delegate: CPXResearchDelegate?
    /// All available surveys
    @objc public var surveys: [SurveyItem] {
        surveyModel?.surveys ?? [SurveyItem]()
    }
    /// All unpaid transactions
    @objc public private(set) var unpaidTransactions = [TransactionModel]()
    /// Convinience property to check for available surveys
    @objc public var hasSurveysAvailable: Bool {
        surveyModel?.availableSurveysCount ?? 0 > 0
    }
    /// Current status of the auto refresh of the available surveys
    @objc public var autoUpdateEnabled: Bool { timer != nil }

    public class func setup(with configuration: CPXConfiguration) {
        CPXResearch.configuration = configuration
    }

    @objc
    public class func setup(with configuration: CPXLegacyConfiguration) {
        setup(with: configuration.asStruct())
    }

    private override init() {
        guard CPXResearch.configuration != nil else {
            fatalError("Please call setup with configuration before attempting to use the CPX Research Framework.")
        }

        super.init()
        requestSurveyUpdate(includeUnpaidTransactions: true)
        activateAutomaticCheckForSurveys()

        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification,
                                               object: nil,
                                               queue: .main) { _ in
            self.installBanner()
        }
    }

    // MARK: public functions

    /// Stops the automatic request for new surveys.
    @objc
    public func deactivateAutomaticCheckForSurveys() {
        timer?.invalidate()
        timer = nil
    }

    /// Starts the automatic request for new surveys.
    @objc
    public func activateAutomaticCheckForSurveys() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: Const.autoUpdateInterval,
                                     repeats: true) { [weak self] _ in
            self?.requestSurveyUpdate()
        }
    }

    /// Allow or disallow showing a survey banner/notification in general.
    /// - Remark: If set to *true* a banner/notification is shown, if there are surveys available, otherwise the banner/notification is never visible.
    /// - Parameter visible: Sets the general visibility of the banner/notification.
    @objc
    public func setSurvey(visible: Bool) {
        shouldShowBannerIfAvailable = visible
    }

    /// Updates the banner/notification that is shown in case of available surveys.
    /// - Parameter newStyle: The new style information for the changed banner.
    public func setStyle(_ newStyle: CPXConfiguration.CPXStyleConfiguration) {
        if var config = CPXResearch.configuration {
            config.style = newStyle
            CPXResearch.configuration = config
            installBanner()
        }
    }

    @objc
    public func setStyle(_ newStyle: CPXLegacyStyleConfiguration) {
        setStyle(newStyle.asStruct())
    }

    /// Request a update on available surveys (and unpaid transactions). New surveys and/or unpaid transactions will be published through the *CPXResearchDelegate*.
    /// - Parameter includeUnpaidTransactions: Set to true if a current list of unpaid transactions should be requested as well.
    @objc
    public func requestSurveyUpdate(includeUnpaidTransactions: Bool = false) {
        guard let conf = CPXResearch.configuration else { return }

        var items = [URLQueryItem]()
        if includeUnpaidTransactions {
            items.append(URLQueryItem(name: Const.showUnpaidTransactions, value: String(true)))
        }
        items.append(contentsOf: conf.queryItems)

        api.requestSurveysFromApi(conf,
                                  additionalQueryItems: items,
                                  onCompletion: onSurveyUpdateDownloaded(_:))
    }

    /// Show the current available surveys in a new viewcontroller presented modally.
    /// - Parameter viewController: The view controller that presents the surveys modally.
    @objc
    public func openSurveyList(on viewController: UIViewController) {
        guard let config = CPXResearch.configuration,
              let url = api.surveyUrl(config) else { return }

        webView = CPXWebView(frame: .zero,
                            delegate: self)
        webViewController = viewController
        webView?.open(on: viewController,
                      for: url,
                      buttons: [.close, .settings, .help])
        delegate?.onSurveysDidOpen()
    }

    /// Show the given survey in a webview in a new viewcontroller presented modally.
    /// - Parameters:
    ///   - id: The survey id of the survey to show.
    ///   - viewController: The view controller that presents the survey modally.
    @objc
    public func openSurvey(by id: String, on viewController: UIViewController) {
        guard let config = CPXResearch.configuration,
              let url = api.surveyUrl(config, showSurvey: id) else { return }

        webView = CPXWebView(frame: .zero,
                             delegate: self)
        webViewController = viewController
        webView?.open(on: viewController,
                      for: url,
                      buttons: [.close, .settings, .help])
    }

    /// Shows the dialog in which the user can select for how long no surveys should be shown.
    /// - Parameter viewController: The view controller that presents the dialog modally.
    @objc
    public func openHideSurveysDialog(on viewController: UIViewController) {
        guard let config = CPXResearch.configuration,
              let url = api.hideDialogUrl(config)
        else { return }

        webView = CPXWebView(frame: .zero,
                            delegate: self)
        webViewController = viewController
        webView?.open(on: viewController,
                      for: url,
                      buttons: [.close])
    }

    /// Tells CPX Research that a transaction has been paid to the user. This removes the transaction from the unpaid list.
    /// - Remark: If the transaction id /message id is invalid this function does not throw any error.
    /// - Parameters:
    ///   - transId: The transaction id of the transaction that has been paid.
    ///   - messageId: The message id of the transaction that has been paid.
    @objc
    public func markTransactionAsPaid(withId transId: String, messageId: String) {
        guard let config = CPXResearch.configuration else { return }
        let items = [
            URLQueryItem(name: Const.transactionMode, value: "full"),
            URLQueryItem(name: Const.setTransactionPaid, value: String(true)),
            URLQueryItem(name: Const.messageId, value: messageId)
        ]

        api.requestSurveysFromApi(config,
                                  additionalQueryItems: items,
                                  onCompletion: onSurveyUpdateDownloaded(_:))

        if let index = unpaidTransactions.firstIndex(where: { $0.id == transId }) {
            self.unpaidTransactions.remove(at: index)
            self.delegate?.onTransactionsUpdated(unpaidTransactions: unpaidTransactions)
        }
    }

    /// Clears the image cache for banners/notifications so the images are reloaded when the banner/notification is refreshed.
    @objc
    public func clearImageCache() {
        api.clearCache()
    }

    // MARK: Banner Handling

    private func installBanner() {
        removeBanner()
        guard shouldShowBannerIfAvailable,
              hasSurveysAvailable,
              webViewController == nil,
              let conf = CPXResearch.configuration,
              let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        bannerView = CPXBannerView(on: window,
                                position: conf.style.position,
                                textModel: surveyModel!.text,
                                backgroundColor: UIColor(hex: conf.style.backgroundColor) ?? .white)
        window.addSubview(bannerView!)
    }

    private func removeBanner() {
        bannerView?.removeFromSuperview()
        bannerView = nil
    }

    func requestImage(onCompletion: @escaping ((Result<ResponseModel, Error>) -> Void)) {
        guard let config = CPXResearch.configuration else { return }
        api.requestImageFor(config, onCompletion: onCompletion)
    }

    // MARK: Internal request response handling

    private func onSurveyUpdateDownloaded(_ result: (Result<SurveyModel, Error>)) {
        switch result {
        case .failure(let error):
            print("Error: \(error)")
        case .success(let model):
            let oldSurveys = self.surveys

            let new = model.surveys.filter { item in
                !oldSurveys.contains { other in
                    item.id == other.id
                }
            }

            let removed = oldSurveys.filter { item in
                !model.surveys.contains(where: { other in
                    item.id == other.id
                })
            }

            let updated = model.surveys.filter { item in
                oldSurveys.contains(where: { other in
                    item.id == other.id && item != other
                })
            }

            DispatchQueue.main.async {
                self.delegate?.onSurveysUpdated(new: new,
                                                updated: updated,
                                                removed: removed)
            }

            if let transactions = model.transactions,
               !transactions.isEmpty {
                self.unpaidTransactions = transactions
                DispatchQueue.main.async {
                    self.delegate?.onTransactionsUpdated(unpaidTransactions: self.unpaidTransactions)
                }
            }

            self.surveyModel = model
            DispatchQueue.main.async {
                self.installBanner()
            }
        }
    }
}

extension CPXResearch: WKNavigationDelegate, CPXWebViewDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let config = CPXResearch.configuration,
           components.queryItems?.first(where: { $0.name == Const.messageId }) != nil,
           let hash = components.queryItems?.first(where: { $0.name == Const.secureHash })?.value {

            let items = [
                URLQueryItem(name: Const.showUnpaidTransactions, value: String(true)),
                URLQueryItem(name: Const.secureHash, value: hash)
            ]

            api.requestSurveysFromApi(config,
                                      additionalQueryItems: items,
                                      onCompletion: onSurveyUpdateDownloaded(_:))
        }

        decisionHandler(.allow)
    }

    func onInfoTapped() {
        print("show info")
    }

    func onSettingsTapped() {
        if let viewController = webViewController?.presentedViewController {
            openHideSurveysDialog(on: viewController)
        }
    }

    func onHelpTapped(session: SupportModel) {
        guard let config = CPXResearch.configuration,
              let url = api.helpSiteUrl(config)
        else { return }

        if let viewController = webViewController?.presentedViewController,
           let json = try? JSONEncoder().encode(session) {
            webView = CPXWebView(frame: .zero,
                                delegate: self)
            webView?.open(on: viewController,
                          for: url,
                          buttons: [.close],
                          body: json)
        }
    }

    func didClose(_ viewController: UIViewController) {
        if viewController == webViewController {
            webViewController = nil
            delegate?.onSurveysDidClose()
        }
    }
}

/// Delegate to receive updates on surveys and unpaid transactions.
@objc
public protocol CPXResearchDelegate: AnyObject {

    /// Called when there are new, updated or surveys removed.
    /// - Parameters:
    ///   - new: New surveys since the last call of this function.
    ///   - updated: Updated surveys since the last call of this function.
    ///   - removed: Surveys not longer available for the user.
    func onSurveysUpdated(new: [SurveyItem],
                          updated: [SurveyItem],
                          removed: [SurveyItem])

    /// Called when unpaid transactions are received.
    /// - Parameter unpaidTransactions: An array of currently unpaid transactions.
    func onTransactionsUpdated(unpaidTransactions: [TransactionModel])

    /// Called after the survey list has been opended.
    func onSurveysDidOpen()
    /// Called after the survey list (or the root CPX Research Webview) has been closed.
    func onSurveysDidClose()
}

#endif
