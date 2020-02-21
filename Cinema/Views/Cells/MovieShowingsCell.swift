//
//  MovieShowingsCell.swift
//  Cinema
//
//  Created by Marius on 18/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class MovieShowingsCell: UITableViewCell {

    let date: UILabel = {
        let label = UILabel()
        label.textColor = .grayC
        label.font = .date
        return label
    }()

    let time: UILabel = {
        let label = UILabel()
        label.textColor = .lightC
        label.font = .time
        return label
    }()

    let venue: UILabel = {
        let label = UILabel()
        label.textColor = .grayC
        label.font = .venue
        return label
    }()

    let screenType: UILabel = {
        let label = UILabel()
        label.textColor = .redC
        label.font = .screenType
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .darkC
        selectionStyle = .none

        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutViews() {
        // `screenType` layout
        contentView.addSubview(screenType)
        screenType.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            screenType.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .inset),
            screenType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.inset)
        ])

        // `date`, `time`, `venue` layout
        let stackView = UIStackView(arrangedSubviews: [date, time, venue])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = .inset

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .inset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2 * .inset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.inset)
        ])
    }
}

extension CGFloat {
    fileprivate static let inset: CGFloat = screenWidth * 0.01
}

extension UIFont {
    fileprivate static let date = UIFont(name: "Avenir-Light", size: .dynamicFontSize(17))
    fileprivate static let time = UIFont(name: "Avenir-Medium", size: .dynamicFontSize(25))
    fileprivate static let venue = UIFont(name: "Avenir-Light", size: .dynamicFontSize(17))
    fileprivate static let screenType = UIFont(name: "Avenir-Light", size: .dynamicFontSize(14))
}
