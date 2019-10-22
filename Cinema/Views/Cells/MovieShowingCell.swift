//
//  MovieShowingCell.swift
//  Cinema
//
//  Created by Marius on 18/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class MovieShowingCell: UITableViewCell {

    let time: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 36.0)!
        return label
    }()

    let date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
        return label
    }()

    let venue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)!
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

        self.contentView.addSubview(time)
        self.contentView.addSubview(date)
        self.contentView.addSubview(venue)

        NSLayoutConstraint.activate([
            time.topAnchor.constraint(lessThanOrEqualTo: self.contentView.topAnchor, constant: 4),
            time.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
        ])

        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            date.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            venue.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            venue.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            venue.topAnchor.constraint(greaterThanOrEqualTo: time.bottomAnchor, constant: 8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
