# Seeker

### **Seeker is a privacy-friendly open-source observability library for Swift applications**

The Seeker library allows developers to easily collect observability data in their mobile applications. The data is processed via [Logstash](https://www.elastic.co/logstash/), [Prometheus](https://www.prometheus.io) and [Zipkin](https://www.zipkin), and then visualized in [Grafana]() and [Kibana](https://www.elastic.co/kibana/).

This library combines [three open-source observability solutions](https://github.com/snkirov/seeker/blob/master/README.md#dependencies) into a single package, thus providing software engineers with a complete picture of how their apps behave in a production environment.

## Features
- Written completly in Swift
- iOS-first, but supports all Apple platforms as well (tvOS, macOS, watchOS)
- SwiftUI integration using property wrappers
- Each application instance gets a randomly generated identifier, which enables developers to synchronize logs, metrics and traces for a given device, while preserving user-privacy. 
- Seeker only communicates with open-source backends which process information on device, ensuring that user data never goes through third-party infrastructure
- By building on top of Apple's packages for [logs](https://github.com/apple/swift-log), [metrics](https://github.com/apple/swift-metrics) and [traces](https://github.com/apple/swift-distributed-tracing), this package can also be used with different observability backends. (As long as there is a swift library, which builds on top of Apple's observability packages, to enable the communication with that backend.)

## Dependencies
- [swift-log-elk](https://github.com/Apodini/swift-log-elk) for logging
- [SwiftPrometheus](https://github.com/swift-server-community/SwiftPrometheus) for metrics
- [opentelemetry-swift](https://github.com/slashmo/opentelemetry-swift) for traces
