//
//  ErrorLabel.swift
//  Cinema
//
//  Created by Marius on 20/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

enum DataError: String, Error {
    case noNetwork = "Nepavyksta pasiekti serverio..."
    case noMovies = "Pasirinktai datai filmų nėra"
    case noShowings = "Pasirinktai datai seansų nėra"
}

final class ErrorLabel: UILabel {

    init(frame: CGRect = .zero, _ error: DataError) {
        super.init(frame: frame)

        textAlignment = .center
        numberOfLines = 0
        textColor = .lightC
        font = UIFont(name: "Avenir-Medium", size: .dynamicFontSize(17))
        text = error.rawValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
