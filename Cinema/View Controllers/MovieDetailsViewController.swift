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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "MovieDetailsView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
    }
}

extension MovieDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        handleScrollDown(offset)
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
        }

        if offset > overlap {
            posterHeight.constant = offset - overlap
            posterTopToSuperview.constant = offset
            posterBottomToDetailsTop.constant = overlap * multi
            detailsBottomToSuperview.constant = -overlap
        }
    }
}
