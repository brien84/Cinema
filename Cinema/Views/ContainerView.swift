//
//  ContainerView.swift
//  Cinema
//
//  Created by Marius on 2020-02-10.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class ContainerView: UIView {

    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)

        return view
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Loading methods

    func startLoading() {
        _ = loadingView
    }

    func stopLoading() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.loadingView.removeFromSuperview()
        }, completion: nil)
    }

    func displayNetworkError() {
        loadingView.display(networkError: true)
    }
}
