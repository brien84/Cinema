//
//  SegmentedControl.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func indexChanged(to newIndex: Int)
}

// TODO: Documentation
class SegmentedControl: UISegmentedControl {
    
    weak var delegate: SegmentedControlDelegate?
    
    // TODO: Set default frame size
    init<T: Segmentable>(frame: CGRect, segments: T.Type) {
        super.init(frame: frame)
        
        self.removeAllSegments()
        
        T.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
        
        self.addTarget(self, action: #selector(valueChange), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func valueChange() {
        delegate?.indexChanged(to: self.selectedSegmentIndex)
    }
}
