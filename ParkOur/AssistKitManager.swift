//
//  AssistKitManager.swift
//  ParkOur
//
//  Created by Yixin Bao on 11/14/19.
//  Copyright © 2019 Yixin Bao. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol AssistKitManagerDelegate: class {
    
    func didDiscoverAssistKit(assistKitManager: AssistKitManager)
    func didConnectToAssistKit(assistKitManager: AssistKitManager)
    func didDisconnectWithAssistKit(assistKitManager: AssistKitManager)
    
}


class AssistKitManager: NSObject {
    
    static let shared = AssistKitManager()
    
    private var connectedPeripheral: CBPeripheral!
    private let centralManager = CBCentralManager()
    
    weak var delegate: AssistKitManagerDelegate?
    
    private let assistKitServiceUUID = CBUUID(string: "980C2C3A-089F-46FE-9177-5DE28ADBCE06")
    
    static func isAlreadyPairedBefore() -> Bool {
        if UserDefaults.standard.string(forKey: Meta.pairedAssistKitKey) != nil {
            return true
        }
        return false
    }
    
    
}


extension AssistKitManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Start discovering
            self.centralManager.scanForPeripherals(withServices: [assistKitServiceUUID], options: nil)
            print("holy")
        default:
            print("shit")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("found you")
        print(peripheral.name ?? "no name")
        self.delegate?.didDiscoverAssistKit(assistKitManager: self)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.delegate?.didConnectToAssistKit(assistKitManager: self)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.delegate?.didDisconnectWithAssistKit(assistKitManager: self)
    }
    
}
