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

public struct TraceHandler {
    
    private var group: EventLoopGroup
    private var otel: OTel
    
    /// Initialises the trace handler, as described here:
    /// https://github.com/slashmo/opentelemetry-swift#bootstrapping
    public init(serviceName: String, hostname: String, port: UInt) {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        let exporter = OtlpGRPCSpanExporter(
            config: OtlpGRPCSpanExporter.Config(eventLoopGroup: group,
                                                host: hostname,
                                                port: port)
        )
        
        let processor = OTel.SimpleSpanProcessor(exportingTo: exporter)
        
        otel = OTel(serviceName: serviceName, eventLoopGroup: group, processor: processor)

        try? otel.start().wait()
        let tracer = otel.tracer()
        InstrumentationSystem.bootstrap(tracer)
        TracerWrapper.tracer = tracer
    }
    
    /// Shuts down the trace handler.
    /// https://github.com/slashmo/opentelemetry-swift#bootstrapping
    public func shutdown() {
        try? otel.shutdown().wait()
        try? group.syncShutdownGracefully()
        TracerWrapper.tracer = nil
    }
    
}
