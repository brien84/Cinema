//
//  NewLoadingView.swift
//  Cinema
//
//  Created by Marius on 2020-11-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class NewLoadingView: UIView {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorMessage: UILabel!
    @IBOutlet private weak var retryButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    @IBAction private func retryButtonDidTap(_ sender: UIButton) {

    }

    private func setup() {
        guard let nib = Bundle.main.loadNibNamed("NewLoadingView", owner: self),
              let view = nib.first as? UIView else { fatalError("Could not load nib!") }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }
}
