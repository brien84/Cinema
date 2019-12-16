//
//  ErrorLabel.swift
//  Cinema
//
//  Created by Marius on 20/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

enum DataError: Error {
    case network
    case noMovies
    case noShowings
}

final class ErrorLabel: UILabel {

    init(frame: CGRect, error: DataError) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: frame.width),
            self.heightAnchor.constraint(equalToConstant: frame.height)
        ])

        switch error {
        case .network:
            self.text = "Nepavyksta pasiekti serverio..."
        case .noMovies:
            self.text = "Pasirinktai datai filmų nėra"
        case .noShowings:
            self.text = "Pasirinktai datai seansų nėra"
        }
        
        self.textColor = Constants.Colors.dark
        self.font = Constants.Fonts.errorLabel
        self.textAlignment = .center
        self.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITableView {
    func setBackground(_ withLabel: Bool, error: DataError?) {
        if withLabel {
            guard let error = error else { return }
            let label = ErrorLabel(frame: self.bounds, error: error)
            self.backgroundView = label
        } else {
            self.backgroundView = nil
        }
    }
}
