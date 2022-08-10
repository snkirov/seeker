//
//  IdentificationService.swift
//  Seeker
//
//  Created by Svilen Kirov on 5.07.22.
//


#if !os(macOS)
import UIKit
#else
import Foundation
#endif

/// A protocol which allows a conformer to provide observability services with an identifier.
public protocol IdentificationService {
    /// The method which provides the identifier.
    /// - Returns: The identifier.
    func getObservabilityIdentifier() -> String
}

/// Default implementation of the Identification service.
/// Randomized Device Id generated by using the sha256 hash of identifier for vendor  concataned with a nonce.
/// Stores the deviceId in user defaults for future use.
public struct DefaultIdentificationService: IdentificationService {
    
    private let deviceIdKey: String = "device-id-key"
    
    public func getObservabilityIdentifier() -> String {
        
        let defaults = UserDefaults.standard
        let existingDeviceId = defaults.string(forKey: deviceIdKey)
        
        guard let existingDeviceId = existingDeviceId else {
            let newDeviceId: String
            newDeviceId = generateRandomizedObservabilityIdentifier()
            print("Generated device Id: \(newDeviceId)")
            defaults.set(newDeviceId, forKey: deviceIdKey)
            
            return newDeviceId
        }
        
        return existingDeviceId
    }
    
    private func generateRandomizedObservabilityIdentifier() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        #if !os(macOS)
        let nonceLength = 16
        #else
        let nonceLength = 64
        #endif
        let nonce = String((0..<nonceLength).map{ _ in letters.randomElement()! })
        
        // TODO: Better handle identifierForVendor being nil
        #if !os(macOS)
        return UIDevice.current.identifierForVendor!.uuidString.appending(nonce).hash256()
        #else
        return nonce.hash256()
        #endif
    }
    
}
