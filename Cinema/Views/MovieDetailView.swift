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
    var year = UILabel()
    var ageRating = UILabel()
    var duration = UILabel()
    var plot = UILabel()
    
    var genres: [String]? {
        didSet {
            createGenreLabels()
        }
    }
    
    private var genreStackView = UIStackView()
    
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
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: -self.unsafeAreaHeight),
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
        genresContainer.addBottomBorder(with: .white, andWidth: 0.1)
        scrollView.addSubview(genresContainer)
        
        NSLayoutConstraint.activate([
            genresContainer.leadingAnchor.constraint(equalTo: poster.leadingAnchor),
            genresContainer.trailingAnchor.constraint(equalTo: poster.trailingAnchor),
            genresContainer.bottomAnchor.constraint(equalTo: poster.bottomAnchor),
            genresContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        
        /// detailStackView layout:
        let detailStackView = makeDetailStackView()
        scrollView.addSubview(detailStackView)

        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 16).withPriority(999),
            detailStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).withPriority(999),
            detailStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).withPriority(999),
            detailStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).withPriority(999)
        ])
    }
    
    private func makeGenresContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Constants.Colors.light.withAlphaComponent(0.7)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        
        self.genreStackView = stackView
        
        container.addSubview(self.genreStackView)
        
        NSLayoutConstraint.activate([
            self.genreStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            self.genreStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            self.genreStackView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -8).withPriority(999),
            self.genreStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).withPriority(999)
        ])
    
        return container
    }
    
    private func makeDetailStackView() -> UIStackView {
        /// Reusable views:
        let verticalStackView = { (spacing: CGFloat) -> UIStackView in
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .equalSpacing
            stackView.spacing = spacing
            
            return stackView
        }

        let horizontalStackView = { () -> UIStackView in
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 0
            
            return stackView
        }

        let staticLabel = { (text: String) -> UILabel in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white
            label.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
            label.textAlignment = .center
            label.text = text
            
            return label
        }

        let dynamicLabel = { () -> UILabel in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .lightGray
            label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
            label.textAlignment = .center
            
            return label
        }
        
        /// year labels into stackView:
        let yearStack = verticalStackView(8)
        let yearStatic = staticLabel("Išleista")
        self.year = dynamicLabel()
        yearStack.addArrangedSubview(yearStatic)
        yearStack.addArrangedSubview(self.year)
        
        /// ageRating labels into stackView:
        let ageStack = verticalStackView(8)
        let ageStatic = staticLabel("Cenzas")
        self.ageRating = dynamicLabel()
        ageStack.addArrangedSubview(ageStatic)
        ageStack.addArrangedSubview(self.ageRating)
        
        /// duration labels into stackView:
        let durationStack = verticalStackView(8)
        let durationStatic = staticLabel("Trukmė")
        self.duration = dynamicLabel()
        durationStack.addArrangedSubview(durationStatic)
        durationStack.addArrangedSubview(self.duration)
        
        /// plot labels into stackView:
        let plotStack = verticalStackView(16)
        plotStack.isLayoutMarginsRelativeArrangement = true
        plotStack.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let plotStatic = staticLabel("Aprašymas")
        self.plot = dynamicLabel()
        self.plot.numberOfLines = 0
        self.plot.textAlignment = .left
        plotStack.addArrangedSubview(plotStatic)
        plotStack.addArrangedSubview(self.plot)
        
        /// year, age, duration stackViews into horizontal stackView:
        let detailBar = horizontalStackView()
        detailBar.isLayoutMarginsRelativeArrangement = true
        detailBar.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        detailBar.addArrangedSubview(yearStack)
        detailBar.addArrangedSubview(ageStack)
        detailBar.addArrangedSubview(durationStack)
        
        detailBar.addBottomBorder(with: .white, andWidth: 0.1)
        
        
        let detailStackView = verticalStackView(16)
        detailStackView.addArrangedSubview(detailBar)
        detailStackView.addArrangedSubview(plotStack)

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
