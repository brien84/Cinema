//
//  ContainerView.swift
//  Cinema
//
//  Created by Marius on 2020-02-10.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class ContainerView: UIView {
    
    private lazy var loadingView = LoadingView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Loading methods
    
    func startLoading() {
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(loadingView)
    }
    
    func stopLoading() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.loadingView.removeFromSuperview()
        }, completion: nil)
    }
    
    func displayNetworkError() {
        loadingView.display(networkError: true)
    }
    
    // MARK: - Animations
    
    func slideIn(from direction: AnimationDirection) {
        guard let superview = superview else { return }
        guard let snapshot = snapshotView(afterScreenUpdates: false) else { return }
        
        superview.addSubview(snapshot)
        superview.sendSubviewToBack(snapshot)
        
        let snapshotDestinationOriginX: CGFloat
        
        switch direction {
        case .left:
            frame.origin.x -= frame.width
            snapshotDestinationOriginX = snapshot.frame.origin.x + snapshot.frame.width
        case .right:
            frame.origin.x += frame.width
            snapshotDestinationOriginX = snapshot.frame.origin.x - snapshot.frame.width
        }
        
        UIView.transition(with: self, duration: 0.5, options: .curveEaseInOut, animations: {
            self.frame.origin.x = 0
            snapshot.frame.origin.x = snapshotDestinationOriginX
            snapshot.alpha = 0.2
        }, completion: { _ in
            snapshot.removeFromSuperview()
        })
    }
}
