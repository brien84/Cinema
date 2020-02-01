//
//  DailyShowingsCell.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class DailyShowingsCell: UITableViewCell {

    let poster = NetworkImageView()
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = Colors.light
        label.font = .dailyShowingsTitle
        label.numberOfLines = 2
        return label
    }()
    
    let originalTitle: UILabel = {
        let label = UILabel()
        label.textColor = Colors.gray
        label.font = .dailyShowingsOriginalTitle
        label.numberOfLines = 2
        return label
    }()
    
    lazy var venue = detailLabel
    lazy var time = detailLabel
    
    lazy var screenType: UILabel = {
        let label = detailLabel
        label.textColor = Colors.red
        return label
    }()
    
    private var detailLabel: UILabel {
        let label = UILabel()
        label.textColor = Colors.gray
        label.font = .dailyShowingsDetailLabel
        label.numberOfLines = 1
        return label
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Colors.dark
        
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        poster.image = nil
    }
    
    private func layoutViews() {
        ///
        contentView.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .dailyShowingsInset),
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .dailyShowingsInset),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.dailyShowingsInset),
            poster.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: .dailyShowingsPosterWidth),
            poster.heightAnchor.constraint(equalTo: poster.widthAnchor, multiplier: .posterAspectRatio).withPriority(999),
        ])
        
        ///
        contentView.addSubview(screenType)
        screenType.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenType.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .dailyShowingsInset),
            screenType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .dailyShowingsInset)
        ])
        
        ///
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .dailyShowingsInset),
            title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 2 * .dailyShowingsInset),
            title.trailingAnchor.constraint(equalTo: screenType.leadingAnchor, constant: -2 * .dailyShowingsInset)
        ])
        
        ///
        contentView.addSubview(originalTitle)
        originalTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            originalTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .dailyShowingsInset),
            originalTitle.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 2 * .dailyShowingsInset),
            originalTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .dailyShowingsInset)
        ])
        
        ///
        let detailStackView = UIStackView(arrangedSubviews: [venue, time])
        detailStackView.axis = .horizontal
        detailStackView.spacing = 2 * .dailyShowingsInset

        contentView.addSubview(detailStackView)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(greaterThanOrEqualTo: originalTitle.bottomAnchor, constant: .dailyShowingsInset),
            detailStackView.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 2 * .dailyShowingsInset),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .dailyShowingsInset),
            detailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.dailyShowingsInset)
        ])
    }
}
