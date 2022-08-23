//
//  TraceHandler.swift
//  Seeker
//
//  Created by Svilen Kirov on 7.06.22.
//

import NIO
import OpenTelemetry
import Tracing
import OtlpGRPCSpanExporting
import Seeker

struct TraceHandler {
  
  private static var group: EventLoopGroup?
  private static var otel: OTel?
  
  /// Initialises the trace handler, as described here:
  /// https://github.com/slashmo/opentelemetry-swift#bootstrapping
  static func setup(serviceName: String, hostname: String, port: UInt) {
    let newGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    
    let exporter = OtlpGRPCSpanExporter(
      config: OtlpGRPCSpanExporter.Config(eventLoopGroup: newGroup,
                                          host: hostname,
                                          port: port)
    )
    
    let processor = OTel.SimpleSpanProcessor(exportingTo: exporter)
    
    let newOtel = OTel(serviceName: serviceName, eventLoopGroup: newGroup, processor: processor)
    
    try? newOtel.start().wait()
    let tracer = newOtel.tracer()
    InstrumentationSystem.bootstrap(tracer)
    Seeker.setupTracer(for: tracer)
    
    group = newGroup
    otel = newOtel
  }
  
  /// Shuts down the trace handler.
  /// https://github.com/slashmo/opentelemetry-swift#bootstrapping
  static func shutdown() {
    guard let otel = otel,
          let group = group else {
      fatalError("Tracer shutdown function called, without calling setup first.")
    }
    try? otel.shutdown().wait()
    try? group.syncShutdownGracefully()
    Seeker.teardownTracer()
  }
  
}
