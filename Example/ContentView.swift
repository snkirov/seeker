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
        NavigationView {
            VStack(spacing: 15) {
                Button(action: generateLog) { Text("Generate Log")
                }
                Button(action: generateMetric) { Text("Generate Metric")
                }
                Button(action: generateTrace) { Text("Generate Trace")
                }
            }
        }
        .navigationTitle("SwiftUI Example")
    }
    
    private func generateLog() {
        logger.log(level: .info, "Just generated log from main screen.")
    }
    
    private func generateMetric() {
        let counter = metrics.createCounter(forType: Int.self, named: "doodle")
        counter.inc()
    }
    
    private func generateTrace() {
        DispatchQueue.global(qos: .background).async {
            let rootSpan = tracer.startSpan("initial_span", baggage: .topLevel)

            sleep(1)
            rootSpan.addEvent(SpanEvent(
                name: "Discovered the meaning of life",
                attributes: ["meaning_of_life": 42]
            ))

            let childSpan = tracer.startSpan("child_span", baggage: rootSpan.baggage)

            sleep(1)
            childSpan.end()

            sleep(1)
            rootSpan.end()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
