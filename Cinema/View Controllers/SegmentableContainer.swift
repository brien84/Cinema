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
        
        /// segmentedControl layout
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
        
        /// separatorView setup
        let separatorView = UIView()
        separatorView.backgroundColor = Constants.Colors.blue
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    
        /// containerView layout
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
    
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        return view
    }
}
