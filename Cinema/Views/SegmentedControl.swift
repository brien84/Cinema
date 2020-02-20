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

    private let selectionIndicator = UIView()
    private var indicatorLeadingAnchorToCenter: NSLayoutConstraint?

    init<T: Segments>(with segments: T.Type) {
        super.init(frame: .zero)

        self.backgroundColor = .transparentBlackC

        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)

        self.setTitleTextAttributes([.foregroundColor: UIColor.grayC], for: .normal)
        self.setTitleTextAttributes([.foregroundColor: UIColor.lightC], for: .selected)

        // Makes separator invisible.
        self.tintColor = .clear

        self.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)

        setupSelectionIndicator()

        T.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        ///
        layer.cornerRadius = 0
    }

    private func setupSelectionIndicator() {
        selectionIndicator.backgroundColor = .redC

        addSubview(selectionIndicator)
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectionIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectionIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 2),
            selectionIndicator.leadingAnchor.constraint(equalTo: leadingAnchor).withPriority(999)
        ])

        indicatorLeadingAnchorToCenter = selectionIndicator.leadingAnchor.constraint(equalTo: centerXAnchor)
    }

    @objc private func valueDidChange() {
        self.layoutIfNeeded()

        UIView.transition(with: selectionIndicator, duration: 0.5, options: .curveEaseInOut, animations: {
            switch self.selectedSegmentIndex {
            case 0:
                self.indicatorLeadingAnchorToCenter?.isActive = false
            case 1:
                self.indicatorLeadingAnchorToCenter?.isActive = true
            default:
                break
            }

            self.layoutIfNeeded()
        }, completion: nil)

        delegate?.segmentedControl(self, didChange: selectedSegmentIndex)
    }

    func setSelectedSegmentIndex(_ index: Int) {
        selectedSegmentIndex = index
        valueDidChange()
    }
}

extension CGFloat {
    static let segmentedControlHeight: CGFloat = screenWidth * 0.1
}
