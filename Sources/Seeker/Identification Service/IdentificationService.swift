//
//  IdentificationService.swift
//  Seeker
//
//  Created by Svilen Kirov on 5.07.22.
//

import Foundation
import UIKit

struct IdentificationService {
    
    private static let deviceIdKey: String = "device-id-key"
    
    static func getRandomizedDeviceId() -> String {
        
        let defaults = UserDefaults.standard
        let existingDeviceId = defaults.string(forKey: deviceIdKey)
        
        guard let existingDeviceId = existingDeviceId else {
            let newDeviceId: String
            newDeviceId = generateRandomizedDeviceId()
            print("Generated device Id: \(newDeviceId)")
            defaults.set(newDeviceId, forKey: deviceIdKey)
            
            return newDeviceId
        }
        
        return existingDeviceId
    }
    
    private static func generateRandomizedDeviceId() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let nonce = String((0..<16).map{ _ in letters.randomElement()! })
        
        // TODO: Better handle identifierForVendor being nil
        return UIDevice.current.identifierForVendor!.uuidString.appending(nonce).hash256()
    }
    
}
