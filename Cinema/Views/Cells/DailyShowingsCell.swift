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
        label.textColor = .lightC
        label.font = .title
        label.numberOfLines = 2
        return label
    }()

    let originalTitle: UILabel = {
        let label = UILabel()
        label.textColor = .grayC
        label.font = .originalTitle
        label.numberOfLines = 2
        return label
    }()

    lazy var venue = detailLabel
    lazy var time = detailLabel

    lazy var screenType: UILabel = {
        let label = detailLabel
        label.textColor = .redC
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

    override func prepareForReuse() {
        super.prepareForReuse()

        poster.image = nil
    }

    private func layoutViews() {
        // `poster` layout
        contentView.addSubview(poster)
        poster.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .inset),
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .inset),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.inset),
            poster.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: .posterWidthToCellWidthRatio),
            poster.heightAnchor.constraint(equalTo: poster.widthAnchor, multiplier: .posterHeightToWidthRatio).withPriority(999)
        ])

        // `screenType` layout
        contentView.addSubview(screenType)
        screenType.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            screenType.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .inset),
            screenType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .inset)
        ])

        // `title` layout
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .inset),
            title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 2 * .inset),
            title.trailingAnchor.constraint(equalTo: screenType.leadingAnchor, constant: -2 * .inset)
        ])

        // `originalTitle` layout
        contentView.addSubview(originalTitle)
        originalTitle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            originalTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .inset),
            originalTitle.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 2 * .inset),
            originalTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .inset)
        ])

        // `venue`, `time` layout
        let detailStackView = UIStackView(arrangedSubviews: [venue, time])
        detailStackView.axis = .horizontal
        detailStackView.spacing = 2 * .inset
        time.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)

        contentView.addSubview(detailStackView)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailStackView.topAnchor.constraint(greaterThanOrEqualTo: originalTitle.bottomAnchor, constant: .inset),
            detailStackView.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 2 * .inset),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * .inset),
            detailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.inset)
        ])
    }
}

extension DailyShowingsCell {
    private var detailLabel: UILabel {
        let label = UILabel()
        label.textColor = .grayC
        label.font = .detail
        label.numberOfLines = 1
        return label
    }
}

extension CGFloat {
    fileprivate static let inset: CGFloat = screenWidth * 0.01
    fileprivate static let posterWidthToCellWidthRatio: CGFloat = 1/4
    fileprivate static let posterHeightToWidthRatio: CGFloat = 3/2
}

extension UIFont {
    fileprivate static let title = UIFont(name: "Avenir-Medium", size: .dynamicFontSize(18))
    fileprivate static let originalTitle = UIFont(name: "Avenir-Oblique", size: .dynamicFontSize(15))
    fileprivate static let detail = UIFont(name: "Avenir-Light", size: .dynamicFontSize(14))
}
