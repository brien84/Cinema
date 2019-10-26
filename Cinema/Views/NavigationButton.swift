//
//  NavigationButton.swift
//  Cinema
//
//  Created by Marius on 22/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol NavigationButtonDelegate: AnyObject {
    func buttonTap(_ sender: NavigationButton)
}

class NavigationButton: UIBarButtonItem {
    
    weak var delegate: NavigationButtonDelegate?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ image: UIImage) {
        super.init()
    
        self.image = image
        self.target = self
        self.action = #selector(tap)
        
        self.tintColor = Constants.Colors.blue
    }
    
    @objc private func tap() {
        delegate?.buttonTap(self)
    }
}
