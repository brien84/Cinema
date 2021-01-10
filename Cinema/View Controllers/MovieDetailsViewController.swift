//
//  MovieDetailsViewController.swift
//  Cinema
//
//  Created by Marius on 2020-07-21.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    var movie: Movie?
    var showing: Showing?

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var poster: NetworkImageView!
    @IBOutlet private weak var movieTitle: CustomFontLabel!
    @IBOutlet private weak var originalTitle: CustomFontLabel!
    @IBOutlet private weak var year: CustomFontLabel!
    @IBOutlet private weak var ageRating: CustomFontLabel!
    @IBOutlet private weak var duration: CustomFontLabel!
    @IBOutlet private weak var plot: CustomFontLabel!
    @IBOutlet private weak var venue: CustomFontLabel!
    @IBOutlet private weak var time: CustomFontLabel!
    @IBOutlet private weak var genresStackView: UIStackView!

    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var detailsContainer: UIView!

    @IBOutlet private weak var posterHeight: NSLayoutConstraint!
    @IBOutlet private weak var posterTopToSuperview: NSLayoutConstraint!
    @IBOutlet private weak var posterBottomToDetailsTop: NSLayoutConstraint!
    @IBOutlet private weak var detailsBottomToSuperview: NSLayoutConstraint!
    @IBOutlet private weak var showingContainerIsCollapsed: NSLayoutConstraint! {
        didSet {
            showingContainerIsCollapsed.isActive = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        setupBackButton()
        setLabels()

        // Appearance setup.
        scrollView.delegate?.scrollViewDidScroll?(scrollView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.transition(with: view, duration: 0.7, options: .curveEaseInOut, animations: {
            self.showingContainerIsCollapsed.isActive = false
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)

        // Resets `navigationBar` appearance.
        navigationBar?.setTitleVerticalPositionAdjustment(0, for: .default)
        navigationBar?.setBackgroundImage(color: .secondaryBackground)
    }

    private func setLabels() {
        navigationItem.title = movie?.title

        poster.url = movie?.poster
        movieTitle.text = movie?.title
        originalTitle.text = movie?.originalTitle
        year.text = movie?.year
        ageRating.text = movie?.ageRating
        duration.text = movie?.duration
        plot.text = movie?.plot

        genresStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movie?.genres.forEach { genre in
            genresStackView.addArrangedSubview(createGenreButton(with: genre))
        }

        venue.text = showing?.venue
        time.text = showing?.date.asString(.timeOfDay)
    }

    private func setupBackButton() {
        let button = UIBarButtonItem(image: .arrowLeft, style: .plain, target: self, action: #selector(popViewController))
        button.tintColor = .primaryElement
        navigationItem.leftBarButtonItem = button
    }

    private func createGenreButton(with title: String) -> UIButton {
        let button = UIButton()
        button.isUserInteractionEnabled = false

        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption2)
        button.setTitleColor(.primaryElement, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.primaryElement.cgColor

        return button
    }
}

extension MovieDetailsViewController: UIScrollViewDelegate {
    private var navigationBar: UINavigationBar? {
        navigationController?.navigationBar
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If `navigationController` is nil, `MovieViewController` is in transition.
        if navigationController != nil {
            // scroll down positive, up negative
            let offset = scrollView.contentOffset.y

            handleScrollDown(offset)
            adjustNavigationBarAlpha(with: offset)
            adjustNavigationBarTitle(with: offset)
            adjustNavigationBarButtons(with: offset)
            adjustPosterViewAlpha(with: offset)
        }
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
            poster.alpha = currentDistance / totalDistance
        } else {
            poster.alpha = 1.0
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
        let currentOverlap = (poster.frame.maxY - detailsContainer.frame.minY) / multi
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
