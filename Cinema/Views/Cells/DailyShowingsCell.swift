//
//  DailyShowingsCell.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class DailyShowingsCell: UITableViewCell {

    let poster = NetworkImageView(frame: .zero)
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.DateContainerCell.title
        label.numberOfLines = 2
        return label
    }()
    
    let originalTitle: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.DateContainerCell.originalTitle
        label.numberOfLines = 2
        return label
    }()
    
    lazy var venue = detailLabel
    lazy var time = detailLabel
    lazy var screenType = detailLabel
    
    private var detailLabel: UILabel {
        let label = UILabel()
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.DateContainerCell.label
        label.numberOfLines = 1
        return label
    }
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.lightBlue
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedBackgroundView = bgView
        self.backgroundColor = Constants.Colors.light
        
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        poster.image = nil
        poster.url = nil
    }
    
    private func layoutViews() {
        ///
        self.contentView.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            poster.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            poster.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            poster.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 3/10),
            poster.heightAnchor.constraint(equalTo: poster.widthAnchor, multiplier: 3/2).withPriority(999),
        ])
        
        ///
        let titleStackView = UIStackView(arrangedSubviews: [title, originalTitle])
        titleStackView.axis = .vertical
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 8
        
        self.contentView.addSubview(titleStackView)
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        venue.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        time.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            titleStackView.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 8),
            titleStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        ])
        
        ///
        let detailStackView = UIStackView(arrangedSubviews: [screenType, venue, time])
        detailStackView.axis = .horizontal
        detailStackView.spacing = 8
        
        self.contentView.addSubview(detailStackView)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(greaterThanOrEqualTo: titleStackView.bottomAnchor, constant: 4),
            detailStackView.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 8),
            detailStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            detailStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ])
    }
}
