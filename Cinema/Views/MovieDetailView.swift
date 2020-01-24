//
//  MovieDetailView.swift
//  Cinema
//
//  Created by Marius on 2020-01-17.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class MovieDetailView: UIView {
    
    let poster = NetworkImageView(frame: .zero)
    lazy var year = dynamicLabel
    lazy var ageRating = dynamicLabel
    lazy var duration = dynamicLabel
    
    lazy var plot: UILabel = {
        let label = dynamicLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var genres: [String]? {
        didSet {
            createGenreLabels()
        }
    }
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private var dynamicLabel: UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        return label
    }
    
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
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: -unsafeAreaHeight),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).withPriority(999)
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
            detailStackView.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16).withPriority(999),
            detailStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).withPriority(999),
            detailStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).withPriority(999),
            detailStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).withPriority(999)
        ])
    }
    
    private func makeGenresContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = Constants.Colors.light.withAlphaComponent(0.7)
        
        container.addSubview(genreStackView)
        genreStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            genreStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            genreStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            genreStackView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -8).withPriority(999),
            genreStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).withPriority(999)
        ])
    
        container.addBottomBorder(with: .white, andWidth: 0.1)
        
        return container
    }
    
    private func makeDetailStackView() -> UIStackView {
        /// Reusable views:
        let verticalStackView = { (views: [UIView], spacing: CGFloat) -> UIStackView in
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.spacing = spacing
            return stackView
        }

        let horizontalStackView = { (views: [UIView]) -> UIStackView in
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            return stackView
        }

        let staticLabel = { (text: String) -> UILabel in
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .white
            label.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
            label.text = text
            return label
        }

        /// year labels into stackView:
        let yearStatic = staticLabel("Išleista")
        let yearStack = verticalStackView([yearStatic, year], 8)
        
        /// ageRating labels into stackView:
        let ageRatingStatic = staticLabel("Cenzas")
        let ageStack = verticalStackView([ageRatingStatic, ageRating], 8)
        
        /// duration labels into stackView:
        let durationStatic = staticLabel("Trukmė")
        let durationStack = verticalStackView([durationStatic, duration], 8)
        
        /// year, age, duration stackViews into horizontal stackView:
        let detailBar = horizontalStackView([yearStack, ageStack, durationStack])
        
        /// plot labels into stackView:
        let plotStatic = staticLabel("Aprašymas")
        let plotStack = verticalStackView([plotStatic, plot], 16)
        plotStack.isLayoutMarginsRelativeArrangement = true
        plotStack.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        
        let detailStackView = verticalStackView([detailBar, plotStack], 16)
        
        return detailStackView
    }
    
    private func createGenreLabels() {
        /// Using `UIButton` instead of `UILabel`, because it is easier to inset content inside.
        let genreLabel = { (name: String) -> UIButton in
            let label = UIButton()
            label.layer.borderWidth = 0.5
            label.layer.cornerRadius = 4.0
            label.layer.borderColor = UIColor.white.cgColor
            label.setTitle(name, for: .normal)
            label.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 10)
            label.setTitleColor(UIColor.white, for: .normal)
            
            label.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            label.isUserInteractionEnabled = false
            
            return label
        }
        
        genres?.forEach { genreStackView.addArrangedSubview(genreLabel($0)) }
    }
}

extension UIView {
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue: priority)
        
        return self
    }
}

extension MovieDetailView {
    var unsafeAreaHeight: CGFloat {
        return navControllerHeight + statusBarHeight
    }
    
    var navControllerHeight: CGFloat {
        let window = UIApplication.shared.keyWindow
        let navController = window?.rootViewController as? UINavigationController
        
        return navController?.navigationBar.frame.height ?? 0.0
    }
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
