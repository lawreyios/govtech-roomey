//
//  Alert+RM.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/24/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

extension Alert {
    
    static var cameraPermissionAlert: Alert {
        Alert(title: Text(InfoText.enableCamera), message: Text(String.empty), dismissButton: .default(Text(RMButtonText.settings), action: {
            UIApplication.goToSettings()
        }))
    }
    
    static var invalidQRCodeAlert: Alert {
        Alert(title: Text(InfoText.invalidQRCode), message: Text(InfoText.invalidQRCodeSubtitle), dismissButton: .default(Text(RMButtonText.ok)))
    }
    
}
