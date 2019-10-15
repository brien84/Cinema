//
//  ContainerVC.swift
//  Cinema
//
//  Created by Marius on 14/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController, SegmentedControlDelegate {
    
    private var container: UIView!
    private var control: SegmentedControl!
    
    var controlSelectedIndex: Int {
        get { return control.selectedSegmentIndex }
        set {
            control.selectedSegmentIndex = newValue
            indexChanged(to: newValue)
        }
    }
    
    private let leftVC: UIViewController
    private let rightVC: UIViewController
    private let segments: Any.Type
    
    init<T: RawRepresentable & CaseIterable>(leftVC: UIViewController, rightVC: UIViewController, segments: T.Type) where T.RawValue == Int {
        self.leftVC = leftVC
        self.rightVC = rightVC
        self.segments = segments
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        // SegmentedControl setup
       
        // TODO: FIX THIS
        var segmentedControl: SegmentedControl
        
        if let segments = segments as? DateVCSegments.Type {
            segmentedControl = SegmentedControl(frame: .zero, segments: segments)
        } else if let segments = segments as? MovieVCSegments.Type {
            segmentedControl = SegmentedControl(frame: .zero, segments: segments)
        } else {
            segmentedControl = SegmentedControl(frame: .zero, segments: DateVCSegments.self)
        }
        //
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControl)
    
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])
    
        segmentedControl.delegate = self
        self.control = segmentedControl
    
        // Container View setup
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
    
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    
        self.container = container
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
    }
    
    // MARK: - Container View methods
    
    private func updateContainer(with viewController: UIViewController) {
        removeCurrentViewController()
        show(viewController)
    }

    private func show(_ viewController: UIViewController) {
        self.addChild(viewController)
        viewController.view.frame = self.container.bounds
        self.container.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    private func removeCurrentViewController() {
        if let viewController = self.children.first {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    // MARK: - SegmentedControlDelegate
    
    func indexChanged(to newIndex: Int) {
        switch newIndex {
        case 0:
            updateContainer(with: leftVC)
        case 1:
            updateContainer(with: rightVC)
        default:
            return
        }
    }
}
