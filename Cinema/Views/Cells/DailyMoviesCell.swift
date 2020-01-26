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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        return label
    }()
    
    let duration: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        return label
    }()
    
    let ageRating: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        poster.image = nil
        poster.url = nil
    }
    
    private func layoutViews() {
        
        contentView.widthAnchor.constraint(equalToConstant: bounds.size.width).isActive = true
        
        ///
        let titleContainer = UIView()

        titleContainer.addSubview(title)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            title.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            title.bottomAnchor.constraint(lessThanOrEqualTo: titleContainer.bottomAnchor)
        ])

        ///
        let titlePlaceholder = UILabel()
        titlePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        titlePlaceholder.numberOfLines = title.numberOfLines
        titlePlaceholder.textColor = title.textColor
        titlePlaceholder.font = title.font
        titlePlaceholder.text = String(repeating: "-", count: 420)
        titlePlaceholder.isHidden = true

        titleContainer.addSubview(titlePlaceholder)

        NSLayoutConstraint.activate([
            titlePlaceholder.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titlePlaceholder.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titlePlaceholder.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            titlePlaceholder.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor)
        ])

        ///
        let detailStackView = UIStackView(arrangedSubviews: [duration, ageRating])
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.axis = .horizontal
        detailStackView.distribution = .equalSpacing

        ///
        let stackView = UIStackView(arrangedSubviews: [poster, titleContainer, detailStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        
        contentView.addSubview(stackView)
    
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).withPriority(999)
        ])
        
        poster.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 3/2).isActive = true
    }
}
