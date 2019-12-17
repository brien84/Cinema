//
//  ContainerVC.swift
//  Cinema
//
//  Created by Marius on 14/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

protocol Segmentable: RawRepresentable, CaseIterable where Self.RawValue == Int {
    var rawValue: Int { get }
}

/// ViewController with SegmentedControl toggle and Container UIView.
/// Switches between leftVC and rightVC depending on SegmentedControl selection.
class ContainerVC: UIViewController, SegmentedControlDelegate {

    private var container: UIView!
    
    var controlSelectedIndex: Int {
        get { return control.selectedSegmentIndex }
        set {
            control.selectedSegmentIndex = newValue
            segmentedControl(control, didChange: newValue)
        }
    }
    
    private let leftVC: UIViewController
    private let rightVC: UIViewController
    private var control: SegmentedControl
    
    init<T: Segmentable>(leftVC: UIViewController, rightVC: UIViewController, segments: T.Type)  {
        self.leftVC = leftVC
        self.rightVC = rightVC
        self.control = SegmentedControl(with: T.self)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Constants.Colors.light
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = Constants.Colors.lightBlue
        } else {
            control.tintColor = Constants.Colors.blue
        }
    }
    
    func toggleSegmentedControl(enabled: Bool) {
        control.isEnabled = enabled
    }
    
    // MARK: - Container View methods
    
    func containerDisplayErrorLabel(_ error: DataError?) {
        if let label = container.subviews.first(where: { type(of: $0) == ErrorLabel.self }) {
            label.removeFromSuperview()
        }
        
        if let error = error {
            let label = ErrorLabel(frame: container.bounds, error: error)
            container.addSubview(label)
        }
    }
    
    private func updateContainer(with viewController: UIViewController) {
        removeCurrentViewController()
        show(viewController)
    }

    private func show(_ viewController: UIViewController) {
        self.addChild(viewController)
        viewController.view.frame = container.bounds
        container.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    private func removeCurrentViewController() {
        if let viewController = self.children.first {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    // MARK: - SegmentedControlDelegate Methods
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didChange index: Int) {
        switch index {
        case 0:
            updateContainer(with: leftVC)
        case 1:
            updateContainer(with: rightVC)
        default:
            return
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        /// SegmentedControl setup
        control.delegate = self
        control.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(control)
        
        NSLayoutConstraint.activate([
            control.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            control.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32),
            control.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32),
        ])
        
        /// Separator View setup
        let separator = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 16),
            separator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        separator.backgroundColor = Constants.Colors.blue
    
        /// Container View setup
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
    
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 0),
            container.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    
        self.container = container
    }
}
