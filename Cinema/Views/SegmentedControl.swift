//
//  SegmentedControl.swift
//  Cinema
//
//  Created by Marius on 23/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

enum DailyViewControllerSegments: Int, CaseIterable {
    case Filmai
    case Seansai
}

class SegmentedControl: UISegmentedControl {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.removeAllSegments()
        DailyViewControllerSegments.allCases.forEach { segment in
            self.insertSegment(withTitle: "\(segment)", at: segment.rawValue, animated: false)
        }
    }
}
