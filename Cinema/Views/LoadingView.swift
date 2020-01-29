//
//  LoadingView.swift
//  Cinema
//
//  Created by Marius on 2020-01-28.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    private let errorLabel: UILabel = {
        let label = ErrorLabel(.noNetwork)
        label.isHidden = true
        
        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.backgroundColor = Constants.Colors.light
        
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayNetworkError(_ shouldDisplayNetworkError: Bool) {
        errorLabel.isHidden = !shouldDisplayNetworkError
    }
    
    private func layoutViews() {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.startAnimating()
        
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            errorLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 12)
        ])
    }
}
