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
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
    
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        /// backgroundImageView layout
        let image = UIColor.white.image(size: SegmentedControl.size, alpha: 0.9)
        let backgroundImageView = UIImageView(image: image)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: SegmentedControl.size.height)
        ])
        
        /// separatorView layout
        let separatorView = UIView()
        separatorView.backgroundColor = Constants.Colors.blue
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        /// segmentedControl layout
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SegmentedControl.inset),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SegmentedControl.inset),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SegmentedControl.inset),
            segmentedControl.heightAnchor.constraint(equalToConstant: SegmentedControl.height)
        ])
        
        return view
    }
}
