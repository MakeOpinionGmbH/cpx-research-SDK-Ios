//
//  BannerView.swift
//  
//
//  Created by Daniel Fredrich on 08.02.21.
//

#if canImport(UIKit)
import Foundation
import UIKit
import Gifu

final class CPXBannerView: UIView {
    private let position: CPXConfiguration.SurveyPosition
    private var bgColor: UIColor

    private var imageView: CPXAnimatedView?
    private var closeBtn: UIImageView?

    private override init(frame: CGRect) {
        fatalError("Direct init with frame only not supported.")
    }

    init(on window: UIWindow,
         position: CPXConfiguration.SurveyPosition,
         textModel: SurveyTextItem,
         backgroundColor: UIColor) {
        self.position = position
        self.bgColor = backgroundColor
        let frame = CPXBannerView.calcRect(for: window, and: position)
        super.init(frame: frame)

        updateView()
        installTapRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateView() {
        let imageView = CPXAnimatedView()
        imageView.delegate = self
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.imageView = imageView

        if case .screen = position {
            let image = UIImage(named: "icon_close", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            let btn = UIImageView(image: image)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.tintColor = .white

            btn.heightAnchor.constraint(equalToConstant: 24).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.addSubview(btn)
            btn.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
            btn.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
            closeBtn = btn
        } else {
            closeBtn?.removeFromSuperview()
            closeBtn = nil
        }

        CPXResearch.shared.requestImage { result in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let model):
                switch model.mimeType {
                case .unknown:
                    break
                case .png:
                    DispatchQueue.main.async {
                        self.imageView?.image = UIImage(data: model.data)
                    }
                case .gif:
                    DispatchQueue.main.async {
                        self.imageView?.animate(withGIFData: model.data)
                    }
                }
            }
        }

        setNeedsLayout()
    }

    private static func calcRect(for window: UIWindow,
                                 and position: CPXConfiguration.SurveyPosition) -> CGRect {
        let safe = window.safeAreaInsets
        let screenSize = window.screen.bounds
        var rect = CGRect.zero

        switch position {
        case .side(let side, _):
            rect = CGRect(x: side == .left ? 0 : (screenSize.width - CGFloat(position.width)),
                          y: (screenSize.height - CGFloat(position.height)) / 2,
                          width: CGFloat(position.width),
                          height: CGFloat(position.height))
        case .corner(let corner):
            rect = CGRect(x: (corner == .topLeft || corner == .bottomLeft) ? 0 : screenSize.width - CGFloat(position.width),
                          y: (corner == .topLeft || corner == .topRight) ? 0 : screenSize.height - CGFloat(position.height),
                          width: CGFloat(position.width),
                          height: CGFloat(position.height))
        case .screen(let pos):
            rect = CGRect(x: (screenSize.width - CGFloat(position.width)) / 2,
                          y: pos == .centerTop ? (0 + safe.top) : (screenSize.height - CGFloat(position.height) - safe.bottom),
                          width: CGFloat(position.width),
                          height: CGFloat(position.height))
        }

        return rect
    }

    private func installTapRecognizer() {
        if let closeBtn = closeBtn {
            closeBtn.isUserInteractionEnabled = true
            closeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseBtnTap(_:))))
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let closeBtn = closeBtn {
            let finalPoint = convert(point, to: closeBtn)
                if closeBtn.point(inside: finalPoint, with: event) {
                    return closeBtn
                }
        }

        return imageView?.hitTest(point, with: event) ?? nil
    }

    @objc
    private func onCloseBtnTap(_ sender: UIGestureRecognizer) {
        if let vc = self.findViewController() {
            CPXResearch.shared.openHideSurveysDialog(on: vc)
        }
    }
}

extension CPXBannerView: CPXAnimatedViewDelegate {
    func onTapped() {
        if let vc = self.findViewController() {
            CPXResearch.shared.openSurveyList(on: vc)
        }
    }
}
#endif
