//
//  DailyMoviesCell.swift
//  Cinema
//
//  Created by Marius on 2020-01-23.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DailyMoviesCell: UICollectionViewCell {
    
    let poster = NetworkImageView()
    
    let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .lightC
        label.font = .title
        return label
    }()
    
    let duration: UILabel = {
        let label = UILabel()
        label.textColor = .grayC
        label.font = .detail
        return label
    }()
    
    let ageRating: UILabel = {
        let label = UILabel()
        label.textColor = .grayC
        label.font = .detail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .darkC
        
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        poster.image = nil
    }
    
    private func layoutViews() {
        
        contentView.widthAnchor.constraint(equalToConstant: bounds.size.width).isActive = true
        
        ///
        let titleContainer = UIView()

        titleContainer.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            title.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            title.bottomAnchor.constraint(lessThanOrEqualTo: titleContainer.bottomAnchor)
        ])

        ///
        let titlePlaceholder = UILabel()
        titlePlaceholder.numberOfLines = title.numberOfLines
        titlePlaceholder.font = title.font
        titlePlaceholder.text = String(repeating: "-", count: 420)
        titlePlaceholder.isHidden = true

        titleContainer.addSubview(titlePlaceholder)
        titlePlaceholder.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titlePlaceholder.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titlePlaceholder.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titlePlaceholder.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            titlePlaceholder.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor)
        ])

        ///
        let detailStackView = UIStackView(arrangedSubviews: [duration, ageRating])
        detailStackView.axis = .horizontal
        detailStackView.distribution = .equalSpacing

        ///
        let stackView = UIStackView(arrangedSubviews: [poster, titleContainer, detailStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = .inset / 2
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).withPriority(999)
        ])
        
        poster.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 3/2).isActive = true
    }
}

extension CGFloat {
    fileprivate static let inset: CGFloat = .screenWidth * 0.03
}

extension UIFont {
    fileprivate static let title = UIFont(name: "Avenir-Medium", size: .dynamicFontSize(17))
    fileprivate static let detail = UIFont(name: "Avenir-Light", size: .dynamicFontSize(14))
}
