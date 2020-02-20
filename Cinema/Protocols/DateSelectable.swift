//
//  DateSelectable.swift
//  Cinema
//
//  Created by Marius on 2020-02-10.
//  Copyright © 2020 Marius. All rights reserved.
//

import Foundation

protocol DateSelectable {
    var current: Date { get }
    var isFirst: Bool { get }
    var isLast: Bool { get }

    func previous()
    func next()
}
