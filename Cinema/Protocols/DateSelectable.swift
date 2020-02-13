//
//  DateSelectable.swift
//  Cinema
//
//  Created by Marius on 2020-02-10.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol DateSelectable {
    var selectedDate: Date { get }
    var isFirstDateSelected: Bool { get }
    var isLastDateSelected: Bool { get }

    func previousDate()
    func nextDate()
}
