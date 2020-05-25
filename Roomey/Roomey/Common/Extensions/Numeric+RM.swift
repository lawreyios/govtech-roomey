//
//  Numeric+RM.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import UIKit

extension Date {
    
    func nearestThirtySeconds() -> Date {
         let cal = Calendar.current
         let startOfMinute = cal.dateInterval(of: .minute, for: self)!.start
         var seconds = self.timeIntervalSince(startOfMinute)
         seconds = (seconds / 30).rounded() * 30
         return startOfMinute.addingTimeInterval(seconds)
     }
    
}

extension CGFloat {
    
    static let textFieldLineHeight: CGFloat = 1.0
    
}
