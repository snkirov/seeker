//
//  ContentView.swift
//  Seeker
//
//  Created by Svilen Kirov on 3.05.22.
//

import SwiftUI
import Tracing

struct ContentView: View {
    @LoggerInstance var logger
    @MetricsInstance var metrics
    @TracerInstance var tracer

    
    var body: some View {
        NavigationLink("Detail Screen", destination: DetailView())
            .onAppear {
                generateLog()
                generateMetric()
                generateTrace()
            }
    }
    
    private func generateLog() {
        logger.log(level: .info, "We are on the main screen.")
    }
    
    private func generateMetric() {
        let counter = metrics.createCounter(forType: Int.self, named: "doodle")
        counter.inc()
    }
    
    private func generateTrace() {
        let rootSpan = tracer.startSpan("hello", baggage: .topLevel)

        sleep(1)
        rootSpan.addEvent(SpanEvent(
            name: "Discovered the meaning of life",
            attributes: ["meaning_of_life": 42]
        ))

        let childSpan = tracer.startSpan("world", baggage: rootSpan.baggage)

        sleep(1)
        childSpan.end()

        sleep(1)
        rootSpan.end()
        
        sleep(1)
        
//        Seeker.tracerTeardown()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
