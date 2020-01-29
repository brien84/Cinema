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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.optionsCell
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                title.textColor = .red
            } else {
                title.textColor = Constants.Colors.dark
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.backgroundColor = Constants.Colors.light
        self.accessoryView?.tintColor = Constants.Colors.blue

        self.contentView.addSubview(title)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            title.heightAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/5).withPriority(999)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
