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
        super.init(coder: aDecoder)
        
        self.target = self
        self.action = #selector(tap)
    }
    
    init(_ title: String) {
        super.init()
        
        self.title = title
        
        self.target = self
        self.action = #selector(tap)
    }
    
    
    @objc private func tap() {
        delegate?.buttonTap(self)
    }
}
