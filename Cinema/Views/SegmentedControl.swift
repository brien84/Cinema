//
//  SegmentedControl.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func segmentedControl(newIndex: Int)
}

class SegmentedControl: UISegmentedControl {
    weak var delegate: SegmentedControlDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.removeAllSegments()
        DailyVCSegments.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
    }
    
    // TODO: init with generics
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.removeAllSegments()
        DailyVCSegments.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
        
        self.addTarget(self, action: #selector(valueChange), for: .valueChanged)
    }
    
    @objc private func valueChange() {
        delegate?.segmentedControl(newIndex: self.selectedSegmentIndex)
    }
}
