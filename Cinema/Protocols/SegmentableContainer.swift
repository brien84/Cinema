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
    var containerView: ContainerView { get }
    
    func updateContainerViewBySegmentedControl(_ index: Int)
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
    
    private func updateContainerView(with viewController: UIViewController) {
        UIView.transition(with: containerView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.removeCurrentViewControllerFromContainerView()
            self.show(viewController)
        }, completion: nil)
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
    
    func constructSegmentableContainerView() -> UIView {
        let view = UIView()
    
        /// containerView layout
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
