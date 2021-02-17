//
//  UIView.swift
//  
//
//  Created by Daniel Fredrich on 08.02.21.
//

#if canImport(UIKit)
import Foundation
import UIKit

extension UIView {
    enum ViewEdges {
        case all
        case top
        case bottom
        case left
        case right
    }

    func rotate(by degrees: CGFloat) {
        let radians = degrees / 180.0 * CGFloat.pi
        let rotation = transform.rotated(by: radians)
        transform = rotation
    }

    func move(x: CGFloat, y: CGFloat) {
        let translation = transform.translatedBy(x: x, y: y)
        transform = translation
    }

    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else if let nextResponder = self as? UIWindow {
            return nextResponder.rootViewController
        } else {
            return nil
        }
    }

    func roundedCorners(by radius: CGFloat, on edges: ViewEdges) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = roundingCorners(from: edges)
    }

    private func roundingCorners(from: ViewEdges) -> CACornerMask {
        switch from {
        case .all:
            return [
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]

        case .top:
            return [
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner
            ]

        case .bottom:
            return [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]

        case .left:
            return [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner
            ]

        case .right:
            return [
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
            ]
        }
    }
}
#endif
