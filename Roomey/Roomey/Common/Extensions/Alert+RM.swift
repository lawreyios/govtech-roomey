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
        Alert(title: Text("Please enable Camera Permission"), message: Text("Go to settings"), dismissButton: .default(Text("Settings"), action: {
            UIApplication.goToSettings()
        }))
    }
    
    static var invalidQRCodeAlert: Alert {
        Alert(title: Text("Invalid QR Code"), message: Text("Please another code"), dismissButton: .default(Text("OK")))
    }
    
}
