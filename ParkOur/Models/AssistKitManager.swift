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
    
    private var connectedPeripheral: CBPeripheral!
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
    
    
}


extension AssistKitManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Start discovering
            self.delegate?.assistKitManagerDidPowerOn(assistKitManager: self)
            self.centralManager.scanForPeripherals(withServices: [assistKitServiceUUID], options: nil)
            print("holy")
        default:
            print("shit")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("found you")
        print(peripheral.name ?? "no name")
        connectedPeripheral = peripheral
        connectedPeripheral.delegate = self
        self.centralManager.stopScan()
        self.centralManager.connect(peripheral, options: nil)
        self.delegate?.didDiscoverAssistKit(assistKitManager: self)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.delegate?.didConnectToAssistKit(assistKitManager: self)
        peripheral.discoverServices([assistKitServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("fuck")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.delegate?.didDisconnectWithAssistKit(assistKitManager: self)
    }
    
    func queryACharacteristic() {
//        connectedPeripheral.readValue(for: [characteristicUUID])
//        connectedPeripheral.readValue(for: connected)
    }
    
    
}

extension AssistKitManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral.services)
        peripheral.discoverCharacteristics([characteristicUUID], for: peripheral.services![0])
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("found characteristic")
        print(service.characteristics)
        
        peripheral.readValue(for: service.characteristics![0])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(String(data: characteristic.value!, encoding: .utf8))
    }
}
