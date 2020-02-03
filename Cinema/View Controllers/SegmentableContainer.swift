//
//  SegmentableContainer.swift
//  Cinema
//
//  Created by Marius on 2019-12-17.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol Segments: RawRepresentable, CaseIterable {
    var rawValue: Int { get }
}

protocol SegmentableContainer: SegmentedControlDelegate where Self: UIViewController {
    associatedtype leftViewControllerType: UIViewController
    associatedtype rightViewControllerType: UIViewController
    
    var leftViewController: leftViewControllerType { get }
    var rightViewController: rightViewControllerType { get }
    var segmentedControl: SegmentedControl { get }
    var containerView: UIView { get }
    
    func updateContainerView(with viewController: UIViewController)
}

extension SegmentableContainer {
    // MARK: SegmentedControlDelegate methods
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didChange index: Int) {
        updateContainerViewBySegmentedControl(index)
    }
    
    // MARK: SegmentableContainer methods
    
    func updateContainerViewBySegmentedControl(_ index: Int) {
        switch index {
        case 0:
            updateContainerView(with: leftViewController)
        case 1:
            updateContainerView(with: rightViewController)
        default:
            return
        }
    }
    
    func updateContainerView(with viewController: UIViewController) {
        removeCurrentViewControllerFromContainerView()
        show(viewController)
    }
    
    private func show(_ viewController: UIViewController) {
        self.addChild(viewController)
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func removeCurrentViewControllerFromContainerView() {
        if let viewController = self.children.first {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    func createSegmentableContainerView() -> UIView {
        let view = UIView()
    
        /// containerView layout
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        /// segmentedControl layout
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: .segmentedControlHeight)
        ])
        
        return view
    }
}
