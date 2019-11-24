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
    
    func assistKitManagerDidPowerOn(assistKitManager: AssistKitManager)
    func didDiscoverAssistKit(assistKitManager: AssistKitManager)
    func didConnectToAssistKit(assistKitManager: AssistKitManager)
    func didDisconnectWithAssistKit(assistKitManager: AssistKitManager)
    
}


class AssistKitManager: NSObject {
    
    static let shared = AssistKitManager()
    
    private var discoveredPeripheral: CBPeripheral!
    private let centralManager = CBCentralManager()
    
    weak var delegate: AssistKitManagerDelegate?
    
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    private let assistKitServiceUUID = CBUUID(string: "980C2C3A-089F-46FE-9177-5DE28ADBCE06")
    private let characteristicUUID = CBUUID(string: "ec0e")
    
    static func isPaired() -> Bool {
        if UserDefaults.standard.string(forKey: Meta.pairedAssistKitKey) != nil {
            return true
        }
        return false
    }
    
    func discoverAssistKit() {
        self.centralManager.scanForPeripherals(withServices: [assistKitServiceUUID], options: nil)
    }
    
    func stopScanning() {
        self.centralManager.stopScan()
    }
    
    func connectToAssistKit() {
        self.centralManager.connect(discoveredPeripheral, options: nil)
    }
    
    
}


extension AssistKitManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Start discovering
            self.delegate?.assistKitManagerDidPowerOn(assistKitManager: self)

        default:
            return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("found you")
        print(peripheral.name ?? "no name")
        discoveredPeripheral = peripheral
        discoveredPeripheral.delegate = self
        self.delegate?.didDiscoverAssistKit(assistKitManager: self)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: Meta.pairedAssistKitKey)
        self.delegate?.didConnectToAssistKit(assistKitManager: self)
        peripheral.discoverServices([assistKitServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.delegate?.didDisconnectWithAssistKit(assistKitManager: self)
    }
    
    func queryACharacteristic() {
//        discoveredPeripheral.readValue(for: [characteristicUUID])
//        discoveredPeripheral.readValue(for: connected)
    }
    
    
}

extension AssistKitManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.discoverCharacteristics([characteristicUUID], for: peripheral.services![0])
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("found characteristic")
        
        peripheral.setNotifyValue(true, for: service.characteristics![0])
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        print("updated value 1")
//        print(characteristic.value)
////        print(String(data: characteristic.value!, encoding: .utf8))
//    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("updated value 2")
        print(characteristic.value)
        print(String(data: characteristic.value!, encoding: .utf8))
    }
    
}
