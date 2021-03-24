//
//  CPXWebView.swift
//  
//
//  Created by Daniel Fredrich on 08.02.21.
//

#if canImport(UIKit)
import Foundation
import UIKit
import WebKit

protocol CPXWebViewDelegate {
    func onHelpTapped(session: SupportModel)
    func onInfoTapped()
    func onSettingsTapped()

    func didClose(_ viewController: UIViewController)
}

final class CPXWebView: WKWebView {

    enum ButtonType: Int {
        case close = 0
        case help
        case info
        case settings
    }

    private weak var delegate: (WKNavigationDelegate & CPXWebViewDelegate)?
    private var supportSession = SupportModel(urls: [String]())

    private weak var viewController: UIViewController?

    init(frame: CGRect,
         configuration: WKWebViewConfiguration = WKWebViewConfiguration(),
         delegate: (WKNavigationDelegate & CPXWebViewDelegate)) {
        super.init(frame: frame,
                   configuration: configuration)
        self.delegate = delegate
        updateView()
    }

    private override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func open(on viewController: UIViewController,
              for url: URL,
              buttons: [ButtonType],
              body: Data? = nil) {
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        bg.isOpaque = false

        let vc = UIViewController()
        vc.modalPresentationStyle = .overFullScreen
        translatesAutoresizingMaskIntoConstraints = false

        let container = UIStackView()
        container.axis = .horizontal
        container.translatesAutoresizingMaskIntoConstraints = false

        let menu = UIStackView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.axis = .vertical
        menu.alignment = .leading

        buttons.forEach { type in
            switch type {
            case .close:
                let closeIcon = createIcon(withImage: "icon_close", iconBackground: .darkGray, tag: .close)
                menu.addArrangedSubview(closeIcon)
            case .help:
                let helpIcon = createIcon(withImage: "icon_help", iconBackground: .lightGray, tag: .help)
                menu.addArrangedSubview(helpIcon)
            case .info:
                let infoIcon = createIcon(withImage: "icon_info", iconBackground: .lightGray, tag: .info)
                menu.addArrangedSubview(infoIcon)
            case .settings:
                let settingsIcon = createIcon(withImage: "icon_settings", iconBackground: .lightGray, tag: .settings)
                menu.addArrangedSubview(settingsIcon)
            }
        }
        menu.addArrangedSubview(UIView())

        container.addArrangedSubview(menu)
        container.addArrangedSubview(self)

        vc.view.addSubview(bg)
        bg.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true

        vc.view.addSubview(container)
        container.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        viewController.present(vc, animated: true)
        self.viewController = vc
        var request = URLRequest(url: url)
        if let body = body {
            request.httpMethod = "POST"
            request.httpBody = body
        }
        self.viewController = vc
        load(request)
    }

    private func createIcon(withImage imageName: String,
                            iconBackground: UIColor?,
                            tag: ButtonType) -> UIView {
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.backgroundColor = .clear
        wrapper.widthAnchor.constraint(equalToConstant: 48).isActive = true
        wrapper.heightAnchor.constraint(equalToConstant: 48).isActive = true

        let iv = UIImageView()
        iv.image = UIImage(named: imageName, in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.backgroundColor = iconBackground
        iv.contentMode = .center
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tag = tag.rawValue
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageViewTap(_:))))
        iv.roundedCorners(by: 8.0, on: .all)

        wrapper.addSubview(iv)
        iv.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 2.0).isActive = true
        iv.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -2.0).isActive = true
        iv.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 2.0).isActive = true
        iv.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -2.0).isActive = true
        
        return wrapper;
    }

    private func updateView() {
        translatesAutoresizingMaskIntoConstraints = false
        navigationDelegate = self
        uiDelegate = self
    }

    @objc
    private func onImageViewTap(_ recognizer: UIGestureRecognizer) {
        guard let ivTag = ButtonType(rawValue: recognizer.view?.tag ?? ButtonType.close.rawValue) else { return }
        switch ivTag {
        case .close:
            if let vc = viewController,
               let presenter = vc.presentingViewController {
                vc.dismiss(animated: true) {
                    self.delegate?.didClose(presenter)
                }
            }
        case .help:
            UIGraphicsBeginImageContext(frame.size)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            supportSession.screenshot = image?.pngData()

            delegate?.onHelpTapped(session: supportSession)
        case .info:
            delegate?.onInfoTapped()
        case .settings:
            delegate?.onSettingsTapped()
        }
    }
}

extension CPXWebView: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            supportSession.urls.append(url.absoluteString)
        }

        if let delegate = delegate {
            delegate.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }
}

#endif
