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

final class SegmentedControl: UISegmentedControl {
    
    weak var delegate: SegmentedControlDelegate?
    
    private lazy var selectionIndicator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .redC
        
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),
            view.heightAnchor.constraint(equalToConstant: 2)
        ])

        return view
    }()
    
    private lazy var leftIndicatorConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: leadingAnchor)
    private lazy var rightIndicatorConstraint = selectionIndicator.trailingAnchor.constraint(equalTo: trailingAnchor)
    
    init<T: Segments>(with segments: T.Type) {
        super.init(frame: .zero)
        
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        
        self.setTitleTextAttributes([.foregroundColor: UIColor.grayC], for: .normal)
        self.setTitleTextAttributes([.foregroundColor: UIColor.lightC], for: .selected)
        
        self.backgroundColor = .transparentBlackC
        /// Makes separator invisible.
        self.tintColor = .clear
        
        self.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        
        T.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 0
    }
    
    @objc private func valueDidChange() {
        switch self.selectedSegmentIndex {
        case 0:
            rightIndicatorConstraint.isActive = false
            leftIndicatorConstraint.isActive = true
        case 1:
            leftIndicatorConstraint.isActive = false
            rightIndicatorConstraint.isActive = true
        default:
            break
        }

        delegate?.segmentedControl(self, didChange: self.selectedSegmentIndex)
    }
}

extension CGFloat {
    static let segmentedControlHeight: CGFloat = screenWidth * 0.1
}
