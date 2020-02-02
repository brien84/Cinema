//
//  OptionsCell.swift
//  Cinema
//
//  Created by Marius on 13/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

final class OptionsCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Colors.light
        label.font = .title
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                title.textColor = Colors.red
            } else {
                title.textColor = Colors.gray
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = Colors.dark

        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            title.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: .titleHeightToWidthRatio).withPriority(999)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CGFloat {
    fileprivate static let titleHeightToWidthRatio: CGFloat = 1/5
}

extension UIFont {
    fileprivate static let title = UIFont(name: "Avenir-Light", size: .dynamicFontSize(18))
}
