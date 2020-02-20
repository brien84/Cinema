//
//  MovieDetailView.swift
//  Cinema
//
//  Created by Marius on 2020-01-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class MovieDetailView: UIView {

    let poster = NetworkImageView()
    lazy var year = dynamicLabel
    lazy var ageRating = dynamicLabel
    lazy var duration = dynamicLabel

    lazy var plot: UILabel = {
        let label = dynamicLabel
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.font = .plotLabel
        return label
    }()

    var genres: [String]? {
        didSet {
            genres?.forEach { genreStackView.addArrangedSubview(genreLabel($0)) }
        }
    }

    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2 * .inset
        return stackView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutViews() {
        /// scrollView layout:
        let scrollView = UIScrollView()

        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: -unsafeAreaHeight),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).withPriority(999)
        ])

        /// poster layout:
        scrollView.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: scrollView.topAnchor),
            poster.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            poster.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            poster.heightAnchor.constraint(equalTo: poster.widthAnchor, multiplier: 3/2)
        ])

        /// genresContainer layout:
        let genresContainer = makeGenresContainer()

        scrollView.addSubview(genresContainer)
        genresContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            genresContainer.leadingAnchor.constraint(equalTo: poster.leadingAnchor),
            genresContainer.trailingAnchor.constraint(equalTo: poster.trailingAnchor),
            genresContainer.bottomAnchor.constraint(equalTo: poster.bottomAnchor),
            genresContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        /// detailStackView layout:
        let detailStackView = makeDetailStackView()

        scrollView.addSubview(detailStackView)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 2 * .inset).withPriority(999),
            detailStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).withPriority(999),
            detailStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).withPriority(999),
            detailStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -2 * .inset).withPriority(999)
        ])
    }

    private func makeGenresContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .transparentBlackC

        container.addSubview(genreStackView)
        genreStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            genreStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: .inset),
            genreStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: .inset),
            genreStackView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -.inset).withPriority(999),
            genreStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -.inset).withPriority(999)
        ])

        container.addBottomBorder(with: .grayC, width: 1.0)

        return container
    }

    private func makeDetailStackView() -> UIStackView {
        /// year labels into stackView:
        let yearStatic = staticLabel("Išleista")
        let yearStack = verticalStackView([yearStatic, year], .inset)

        /// ageRating labels into stackView:
        let ageRatingStatic = staticLabel("Cenzas")
        let ageStack = verticalStackView([ageRatingStatic, ageRating], .inset)

        /// duration labels into stackView:
        let durationStatic = staticLabel("Trukmė")
        let durationStack = verticalStackView([durationStatic, duration], .inset)

        /// year, age, duration stackViews into horizontal stackView:
        let detailBar = horizontalStackView([yearStack, ageStack, durationStack])

        /// plot labels into stackView:
        let plotStatic = staticLabel("Aprašymas")
        let plotStack = verticalStackView([plotStatic, plot], 2 * .inset)
        plotStack.isLayoutMarginsRelativeArrangement = true
        plotStack.layoutMargins = UIEdgeInsets(top: 0, left: 2 * .inset, bottom: 0, right: 2 * .inset)

        let detailStackView = verticalStackView([detailBar, plotStack], 2 * .inset)

        return detailStackView
    }
}

// MARK: - Reusable views:

extension MovieDetailView {
    private var staticLabel: (String) -> UILabel {
        return { (text: String) -> UILabel in
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .lightC
            label.font = .staticLabel
            label.text = text

            return label
        }
    }

    private var dynamicLabel: UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .grayC
        label.font = .dynamicLabel

        return label
    }

    /// Using `UIButton` instead of `UILabel`, because it is easier to inset content inside.
    private var genreLabel: (String) -> UIButton {
        return { (name: String) -> UIButton in

            let label = UIButton()
            label.layer.borderWidth = 0.5
            label.layer.cornerRadius = 4.0
            label.layer.borderColor = UIColor.lightC.cgColor
            label.setTitle(name, for: .normal)
            label.titleLabel?.font = .genreLabel
            label.setTitleColor(.lightC, for: .normal)

            label.contentEdgeInsets = UIEdgeInsets(top: .inset / 1.5, left: .inset, bottom: .inset / 1.5, right: .inset)
            label.isUserInteractionEnabled = false

            return label
        }
    }

    private var verticalStackView: ([UIView], CGFloat) -> UIStackView {
        return { (views: [UIView], spacing: CGFloat) -> UIStackView in

            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.spacing = spacing

            return stackView
        }
    }

    private var horizontalStackView: ([UIView]) -> UIStackView {
        return { (views: [UIView]) -> UIStackView in

            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually

            return stackView
        }
    }
}

extension MovieDetailView {
    private var unsafeAreaHeight: CGFloat {
        return navControllerHeight + statusBarHeight
    }

    private var navControllerHeight: CGFloat {
        let window = UIApplication.shared.keyWindow
        let navController = window?.rootViewController as? UINavigationController

        return navController?.navigationBar.frame.height ?? 0.0
    }

    private var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}

extension CGFloat {
    fileprivate static let inset: CGFloat = screenWidth * 0.017
}

extension UIFont {
    fileprivate static let staticLabel = UIFont(name: "Avenir-Medium", size: .dynamicFontSize(16))
    fileprivate static let dynamicLabel = UIFont(name: "Avenir-Book", size: .dynamicFontSize(15))
    fileprivate static let genreLabel = UIFont(name: "Avenir-Light", size: .dynamicFontSize(10))
    fileprivate static let plotLabel = UIFont(name: "Avenir-Book", size: .dynamicFontSize(15))
}
