//
//  StringConstants.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/23/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

struct QRCode {
    static var domain = "qrgo.page.link"
}

struct InfoText {
    static var loading = "Loading ..."
    static var noInternet = "No internet connection\nPlease check your settings"
    static var enableCamera = "Please enable Camera Permission"
    static var invalidQRCode = "Invalid QR Code"
    static var invalidQRCodeSubtitle = "Invalid QR Code"
}

struct RoomAvailabilityCard {
    static var levelText = "Level"
    static var paxText = "Pax"
    static var availableText = "Available"
    static var notAvailableText = "Not Available"
}

struct DateTimeFormat {
    static var dateWithMonthName =  "dd MMM yyyy"
    static var timeWithAMPM = "hh:mm a"
    static var timeInHours = "HH:mm"
}

struct TextFieldTitle {
    static var date = "Date"
    static var timeslot = "Timeslot"
}

struct PageTitle {
    static var bookRoom = "Book a Room"
    static var sort = "Sort"
}

struct SectionTitle {
    static var rooms = "Rooms"
}

struct RMButtonText {
    static var sort = "Sort"
    static var reset = "Reset"
    static var apply = "Apply"
    static var backToHome = "Back to Home"
    static var settings = "Settings"
    static var ok = "OK"
}

struct SMFont {
    static let regular = "Chivo-Regular"
    static let bold = "Chivo-Bold"
    static let extraBold = "Chivo-ExtraBold"
    static let medium = "Chivo-Medium"
    static let lightItalic = "Chivo-LightItalic"
}
