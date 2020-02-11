//
//  LoadingView.swift
//  Cinema
//
//  Created by Marius on 2020-01-28.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.startAnimating()
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = ErrorLabel(.noNetwork)
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.backgroundColor = .darkC
        
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(networkError shouldDisplay: Bool) {
        errorLabel.isHidden = !shouldDisplay
    }
    
    private func layoutViews() {

        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: .inset),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: .inset)
        ])
    }
}

extension CGFloat {
    fileprivate static let inset: CGFloat = screenWidth * 0.025
}
