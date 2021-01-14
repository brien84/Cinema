//
//  GradientBackgroundView.swift
//  Cinema
//
//  Created by Marius on 2020-07-23.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

@IBDesignable
final class GradientBackgroundView: UIView {
    @IBInspectable
    var startColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    @IBInspectable
    var endColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    @IBInspectable
    var startColorAlpha: Double = 1.0 {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    @IBInspectable
    var endColorAlpha: Double = 1.0 {
        didSet { gradientLayer.colors = cgColorGradient }
    }

    @IBInspectable
    var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet { gradientLayer.startPoint = startPoint }
    }

    @IBInspectable
    var endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0) {
        didSet { gradientLayer.endPoint = endPoint }
    }

    private var gradientLayer: CAGradientLayer {
        // swiftlint:disable:next force_cast
        return layer as! CAGradientLayer
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
}

private extension GradientBackgroundView {
    var cgColorGradient: [CGColor]? {
        guard let startColor = startColor?.withAlphaComponent(CGFloat(startColorAlpha)),
              let endColor = endColor?.withAlphaComponent(CGFloat(endColorAlpha))
        else { return nil }

        return [startColor.cgColor, endColor.cgColor]
    }
}
