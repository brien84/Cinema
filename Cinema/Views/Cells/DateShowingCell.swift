//
//  DateShowingCell.swift
//  Cinema
//
//  Created by Marius on 2020-08-06.
//  Copyright © 2020 Marius. All rights reserved.
//

import UIKit

final class DateShowingCell: UITableViewCell {
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var is3D: UILabel!
}
