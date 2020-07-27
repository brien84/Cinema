//
//  MovieDetailsViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-21.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var posterView: UIImageView!
    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailsContainer: UIView!
    @IBOutlet private weak var plotLabel: UILabel!

    @IBOutlet private weak var posterHeight: NSLayoutConstraint!
    @IBOutlet private weak var posterTopToSuperview: NSLayoutConstraint!
    @IBOutlet private weak var posterBottomToDetailsTop: NSLayoutConstraint!
    @IBOutlet private weak var detailsBottomToSuperview: NSLayoutConstraint!

    private lazy var navigationBar = navigationController?.navigationBar

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "MovieDetailsView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        navigationItem.title = "Title"

        if let navigationBar = navigationBar {
            navigationBar.setBackgroundColor(nil)
            navigationBar.setTitleAlpha(0.0)

            let leftButton = UIBarButtonItem(image: .left, style: .plain, target: nil, action: nil)

            leftButton.setBackground(color: .grayC, with: 1.0, in: navigationBar)

            let navBarInset = navigationBar.frame.width * 0.02
            leftButton.imageInsets = UIEdgeInsets(top: 0, left: navBarInset, bottom: 0, right: 0)

            navigationItem.leftBarButtonItem = leftButton
        }
    }
}

extension MovieDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        handleScrollDown(offset)
        adjustNavigationBarTitle(with: offset)
        adjustPosterViewAlpha(with: offset)
        adjustNavigationBarAlpha(with: offset)
        adjustNavigationBarButtons(with: offset)
    }

    private func adjustNavigationBarButtons(with offset: CGFloat) {
        guard let navigationBar = navigationBar else { return }
        guard let leftButton = navigationItem.leftBarButtonItem else { return }

        let totalDistance = titleContainer.frame.minY - navigationBar.frame.maxY
        let currentDistance = totalDistance - offset

        let navBarInset = navigationBar.frame.width * 0.02

        if currentDistance > navigationBar.frame.height {
            leftButton.setBackground(color: .grayC, in: navigationBar)
            leftButton.imageInsets = UIEdgeInsets(top: 0, left: navBarInset, bottom: 0, right: 0)
        }

        if currentDistance <= navigationBar.frame.height {
            let percentage = currentDistance / navigationBar.frame.height

            leftButton.setBackground(color: .grayC, with: percentage, in: navigationBar)
            leftButton.imageInsets = UIEdgeInsets(top: 0, left: navBarInset * percentage, bottom: 0, right: 0)
        }

        if currentDistance < 0 {
            leftButton.setBackground(color: .grayC, with: 0.0, in: navigationBar)
            leftButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    private func adjustNavigationBarAlpha(with offset: CGFloat) {
        guard let navigationBar = navigationBar else { return }

        let totalDistance = titleContainer.frame.minY - navigationBar.frame.maxY
        let currentDistance = totalDistance - offset

        let height = titleContainer.frame.height

        if currentDistance < 0 {
            let alpha = (1 - (height + currentDistance) / height)
            navigationBar.setBackgroundColor(.darkC, alpha: alpha)
        } else {
            navigationBar.setBackgroundColor(nil)
        }
    }

    private func adjustPosterViewAlpha(with offset: CGFloat) {
        guard let navigationBar = navigationBar else { return }

        if offset > 0 {
            let totalDistance = titleContainer.frame.minY - navigationBar.frame.maxY
            let currentDistance = totalDistance - offset
            posterView.alpha = currentDistance / totalDistance
        } else {
            posterView.alpha = 1.0
        }
    }

    private func adjustNavigationBarTitle(with offset: CGFloat) {
        guard let navigationBar = navigationBar else { return }

        // Distance between bottom borders of `titleContainer` and `navigationBar`.
        // If distance is 0, it means `titleContainer` is fully covered by `navigationBar`.
        let totalDistance = titleContainer.frame.maxY - navigationBar.frame.maxY
        let currentDistance = totalDistance - offset

        // Height is halved, because title is adjusted up until `navigationBar` vertical center.
        let navBarHeight = navigationBar.frame.height / 2

        if currentDistance < 0 {
            navigationBar.setTitleAlpha(1.0)
            navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
            return
        }

        if currentDistance > navBarHeight {
            navigationBar.setTitleAlpha(0.0)
        }

        if currentDistance < navBarHeight {
            navigationBar.setTitleAlpha(1.0 - currentDistance / navBarHeight)
            navigationBar.setTitleVerticalPositionAdjustment(currentDistance, for: .default)
        }
    }

    private func handleScrollDown(_ offset: CGFloat) {
        // Convert offset to positive number for clearer calculations.
        let offset = -offset

        // If scrolling upwards.
        if offset <= 0 {
            posterHeight.constant = 0
            posterTopToSuperview.constant = 0
            posterBottomToDetailsTop.constant = 0
            detailsBottomToSuperview.constant = 0

            titleContainer.alpha = 1.0
            return
        }

        let multi = 1 + posterBottomToDetailsTop.multiplier

        // `overlap` is distance by which `detailsContainer` overlaps `posterView`.
        // In other words - how much can we scroll before `detailsContainer` is not overlapping `posterView`.
        let currentOverlap = (posterView.frame.maxY - detailsContainer.frame.minY) / multi
        let overlap = currentOverlap + posterBottomToDetailsTop.constant / multi

        if offset > 0, offset <= overlap {
            posterHeight.constant = 0
            posterTopToSuperview.constant = offset
            posterBottomToDetailsTop.constant = offset * multi
            detailsBottomToSuperview.constant = -offset

            titleContainer.alpha = 1.0 - offset / overlap
        }

        if offset > overlap {
            posterHeight.constant = offset - overlap
            posterTopToSuperview.constant = offset
            posterBottomToDetailsTop.constant = overlap * multi
            detailsBottomToSuperview.constant = -overlap

            titleContainer.alpha = 0.0
        }
    }
}

extension UINavigationBar {
    func setTitleAlpha(_ alpha: CGFloat) {
        self.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(alpha)]
    }

    func setBackgroundColor(_ color: UIColor?, alpha: CGFloat = 1.0) {
        if let color = color?.withAlphaComponent(alpha) {
            let image = color.image(size: self.frame.size)
            self.setBackgroundImage(image, for: .default)
        } else {
            self.setBackgroundImage(UIImage(), for: .default)
        }
    }
}

extension UIBarButtonItem {
    fileprivate func setBackground(color: UIColor, with alpha: CGFloat = 1.0, in navBar: UINavigationBar) {
        let height = navBar.frame.height * 0.8
        let size = CGSize(width: height, height: height)
        let image = color.withAlphaComponent(alpha).image(size: size, isEclipse: true)
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
    }
}
