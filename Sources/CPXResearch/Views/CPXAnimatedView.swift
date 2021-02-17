//
//  CPXAnimatedView.swift
//  
//
//  Created by Daniel Fredrich on 17.02.21.
//

#if canImport(UIKit)
import Foundation
import UIKit
import Gifu

protocol CPXAnimatedViewDelegate: AnyObject {
    func onTapped()
}

class CPXAnimatedView: UIImageView, GIFAnimatable {
    
    private var tapRecognizer: UIGestureRecognizer?

    weak var delegate: CPXAnimatedViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        tapRecognizer = UITapGestureRecognizer(target: self,
                                               action: #selector(onTap(_:)))
        addGestureRecognizer(tapRecognizer!)
    }

    /// A lazy animator.
    public lazy var animator: Animator? = {
        return Animator(withDelegate: self)
    }()

    /// Layer delegate method called periodically by the layer. **Should not** be called manually.
    ///
    /// - parameter layer: The delegated layer.
    override public func display(_ layer: CALayer) {
        if UIImageView.instancesRespond(to: #selector(display(_:))) {
            super.display(layer)
        }
        updateImageIfNeeded()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let scaledPoint = CGPoint(x: point.x * UIScreen.main.scale,
                                  y: point.y * UIScreen.main.scale)

        if self.point(inside: point, with: event),
           let color = image?.getPixelColor(pos: scaledPoint),
           !color.isClear {
            return self
        }
        
        return nil
    }

    @objc
    private func onTap(_ recognizer: UITapGestureRecognizer) {
        delegate?.onTapped()
    }
}
#endif
