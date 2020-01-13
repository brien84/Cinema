//
//  ErrorLabel.swift
//  Cinema
//
//  Created by Marius on 20/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

enum DataError: String, Error {
    case network = "Nepavyksta pasiekti serverio..."
    case noMovies = "Pasirinktai datai filmų nėra"
    case noShowings = "Pasirinktai datai seansų nėra"
}

final class ErrorLabel: UILabel {

    init(frame: CGRect, error: DataError) {
        super.init(frame: .zero)
        
        self.textAlignment = .center
        self.numberOfLines = 0
        self.backgroundColor = Constants.Colors.light
        self.textColor = Constants.Colors.dark
        self.font = Constants.Fonts.errorLabel
        
        self.text = error.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
