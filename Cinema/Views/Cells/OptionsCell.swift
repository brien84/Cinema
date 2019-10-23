//
//  OptionsCell.swift
//  Cinema
//
//  Created by Marius on 13/10/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

class OptionsCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.dark
        label.font = Constants.Fonts.optionsCell
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.backgroundColor = Constants.Colors.light
        self.accessoryView?.tintColor = Constants.Colors.blue

        self.contentView.addSubview(title)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
