//
//  Meta.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/14/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation

struct Meta {
    static let pairedAssistKitKey = "com.parkour.assistkit_identifier"
    
    static let serviceUUID = "980C2C3A-089F-46FE-9177-5DE28ADBCE06"
    static let characterUUID = "99083242-78FC-42D3-85DB-567AC9E3BF43"
    
    // Beginning of empty spots
    static let startCode = 0
    
    // End of empty spots
    static let endCode = 1
    
    static let noChangeCode = 2
}

extension Notification.Name {
    static let assistKitPairStateDidChange = Notification.Name("assistKitPairStateDidChange")
    static let initPairingProcess = Notification.Name(rawValue: "initPairingProcess")
    static let connectToFoundAssistKit = Notification.Name(rawValue: "connectToFoundAssistKit")
    
    static let findParkedCar = Notification.Name("findParkedCar")
}
