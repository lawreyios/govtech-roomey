//
//  UIApplication+RM.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/24/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

extension UIApplication {
    static func goToSettings() {
        guard let settingsUrl = URL(string: openSettingsURLString) else {
            return
        }
        
        if shared.canOpenURL(settingsUrl) {
            shared.open(settingsUrl)
        }
    }
}
