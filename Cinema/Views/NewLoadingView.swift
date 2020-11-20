//
//  NewLoadingView.swift
//  Cinema
//
//  Created by Marius on 2020-11-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

enum LoadingError: String, Error {
    case none = ""
    case noNetwork = "Nepavyksta pasiekti serverio..."
    case noMovies = "Šią dieną filmų nėra"
}

protocol LoadingViewDelegate: AnyObject {
    func loadingView(_ view: NewLoadingView, retryButtonDidTap: UIButton)
}

final class NewLoadingView: UIView {
    weak var delegate: LoadingViewDelegate?

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
        startLoading()
        delegate?.loadingView(self, retryButtonDidTap: sender)
    }

    func startLoading() {
        retryButton.isHidden = true
        display(error: .none)
        activityIndicator.startAnimating()
    }

    func display(error: LoadingError) {
        activityIndicator.stopAnimating()
        retryButton.isHidden = error == .noNetwork ? false : true
        errorMessage.text = error.rawValue
        self.isHidden = false
    }

    private func setup() {
        guard let nib = Bundle.main.loadNibNamed("NewLoadingView", owner: self),
              let view = nib.first as? UIView else { fatalError("Could not load nib!") }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }
}
