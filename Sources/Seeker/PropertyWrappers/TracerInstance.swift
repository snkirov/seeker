//
//  TracerInstance.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import SwiftUI
import Tracing

@propertyWrapper
public struct TracerInstance: DynamicProperty {
  
  public init() {}
  
  public var wrappedValue: Tracer {
    get { Seeker.tracer }
  }
}
