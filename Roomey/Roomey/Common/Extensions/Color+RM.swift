//
//  Color+RM.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/25/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

enum AppColor {
    case hanBlue
    case arsenic
    case whiteSmoke
    case chateauGreen
    case crayonBlue
    case charcoal
    case starDust
    case submarine
    
    var name: String {
        switch self {
        case .hanBlue:
            return "hanBlue"
        case .arsenic:
            return "arsenic"
        case .whiteSmoke:
            return "whiteSmoke"
        case .chateauGreen:
            return "chateauGreen"
        case .crayonBlue:
            return "crayonBlue"
        case .charcoal:
            return "charcoal"
        case .starDust:
            return "starDust"
        case .submarine:
            return "submarine"
        }
    }
}

extension Color {
    
    static func appColor(_ color: AppColor) -> Color? {
        return Color(color.name)
    }
    
}

