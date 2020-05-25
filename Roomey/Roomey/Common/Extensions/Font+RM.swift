//
//  Font+RM.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/25/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

enum AppFont {
    case regular
    case medium
    case bold
    case extraBold
    case lightItalic
}

extension Font {
    
    static func appFont(_ name: AppFont, size: CGFloat) -> Font? {
        switch name {
        case .regular: return Font.custom(SMFont.regular, size: size)
        case .bold: return Font.custom(SMFont.bold, size: size)
        case .extraBold: return Font.custom(SMFont.extraBold, size: size)
        case .medium: return Font.custom(SMFont.medium, size: size)
        case .lightItalic: return Font.custom(SMFont.lightItalic, size: size)
        }
    }
    
}

struct FontModifier: ViewModifier {
    
    var appFont: AppFont
    var size: CGFloat
    var color: Color?
    
    func body(content: Content) -> some View {
        content.font(Font.appFont(appFont, size: size)).foregroundColor(color)
    }
    
}
