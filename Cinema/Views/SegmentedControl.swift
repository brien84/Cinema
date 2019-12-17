//
//  SegmentedControl.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func segmentedControl(_ segmentedControl: SegmentedControl, didChange index: Int)
}

// TODO: Documentation
final class SegmentedControl: UISegmentedControl {
    
    weak var delegate: SegmentedControlDelegate?
    
    init<T: Segmentable>(with segments: T.Type) {
        super.init(frame: .zero)
        
        self.removeAllSegments()
        
        T.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
        
        self.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func valueDidChange() {
        delegate?.segmentedControl(self, didChange: self.selectedSegmentIndex)
    }
}
