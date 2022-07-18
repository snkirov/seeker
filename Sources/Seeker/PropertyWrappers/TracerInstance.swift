//
//  TracerInstance.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import SwiftUI
import Tracing

@propertyWrapper
struct TracerInstance: DynamicProperty {
    
    var wrappedValue: Tracer {
        get {
            TracerWrapper.tracer!
        }
    }
}
