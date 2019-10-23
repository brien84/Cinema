//
//  DateContainerCell.swift
//  Cinema
//
//  Created by Marius on 25/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class DateContainerCell: UITableViewCell {

    let poster: NetworkImageView = {
        let view = NetworkImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.DateContainerCell.title
        label.numberOfLines = 0
        return label
    }()
    
    let originalTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.gray
        label.font = Constants.Fonts.DateContainerCell.originalTitle
        label.numberOfLines = 0
        return label
    }()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.DateContainerCell.label
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.DateContainerCell.label
        return label
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.lightBlue
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedBackgroundView = bgView
        self.backgroundColor = Constants.Colors.light
        
        self.contentView.addSubview(poster)
        self.contentView.addSubview(title)
        self.contentView.addSubview(originalTitle)
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            poster.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            poster.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            poster.widthAnchor.constraint(equalTo: poster.heightAnchor, multiplier: 2/3),
        ])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            originalTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            originalTitle.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 8),
            originalTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 8),
            leftLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 8),
            rightLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            rightLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
