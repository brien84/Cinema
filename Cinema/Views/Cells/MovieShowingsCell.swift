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
        label.textColor = .lightGray
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 20.0)!
        return label
    }()

    let time: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 30.0)!
        return label
    }()

    let venue: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 21.0)!
        return label
    }()
    
    let screenType: UILabel = {
        let label = UILabel()
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
    
        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutViews() {
        self.contentView.addSubview(screenType)
        screenType.translatesAutoresizingMaskIntoConstraints = false
          
        NSLayoutConstraint.activate([
            screenType.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            screenType.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [date, time, venue])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: screenType.leadingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
