//
//  CustomFontLabel.swift
//  Cinema
//
//  Created by Marius on 2020-09-04.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

@IBDesignable final class CustomFontLabel: UILabel {

    @IBInspectable private var fontIdentifier: String? {
        didSet {
            guard let identifier = fontIdentifier else { return }
            let font = Fonts.getFont(identifier)
            self.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
            self.adjustsFontForContentSizeCategory = true
        }
    }

}
