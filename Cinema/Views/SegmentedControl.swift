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
    
    private lazy var selectionIndicator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .red
        
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),
            view.heightAnchor.constraint(equalToConstant: 2)
        ])

        return view
    }()
    
    private lazy var leftIndicatorConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor)
    private lazy var rightIndicatorConstraint = selectionIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    
    init<T: Segments>(with segments: T.Type) {
        super.init(frame: .zero)
        
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = Constants.Colors.lightBlue
        } else {
            self.tintColor = Constants.Colors.blue
        }
        
        T.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)

        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

        self.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 0
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

extension SegmentedControl {
    static var height: CGFloat {
        return UIScreen.main.bounds.width * 0.1
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width * 1.05
    }
    
    static var inset: CGFloat {
        return UIScreen.main.bounds.width * 0.025
    }
    
    /// 
    static var size: CGSize {
        let width = UIScreen.main.bounds.width
        let height = self.height
        return CGSize(width: width, height: height)
    }
}
