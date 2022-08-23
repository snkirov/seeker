# Seeker

### **Seeker is a privacy-friendly open-source observability library for Swift applications**

The Seeker library allows developers to easily collect observability data in their mobile applications. The data is processed via [Logstash](https://www.elastic.co/logstash/), [Prometheus](https://www.prometheus.io) and [Zipkin](https://www.zipkin), and then visualized in [Grafana](https://grafana.com/) and [Kibana](https://www.elastic.co/kibana/).

This library combines [three open-source observability solutions](https://github.com/snkirov/seeker/blob/master/README.md#dependencies) into a single package, thus providing software engineers with a complete picture of how their apps behave in a production environment.

For example projects using this library see [seeker-swift-examples](https://github.com/snkirov/seeker-swift-examples).

For an example backend services setup see [seeker-docker-example](https://github.com/snkirov/seeker-docker-example).

## Features
- Written completly in Swift
- iOS-first, but supports macOS as well
- SwiftUI integration using property wrappers
- Each application instance gets a randomly generated identifier, which enables developers to synchronize logs, metrics and traces for a given device, while preserving user-privacy. 
- Seeker only communicates with open-source backends which process information on device, ensuring that user data never goes through third-party infrastructure, thus the framework is completely transparent.
- By building on top of Apple's packages for [logs](https://github.com/apple/swift-log), [metrics](https://github.com/apple/swift-metrics) and [traces](https://github.com/apple/swift-distributed-tracing), this package can also be used with different observability backends. (As long as there is a swift library, which builds on top of Apple's observability packages, to enable the communication with that backend.)

## Description

The Seeker library facilitates the collection of the three main types of observability data - logs, metrics and traces.

For an example backend services setup see [seeker-docker-example](https://github.com/snkirov/seeker-docker-example).

### Logs

For the logs we send the data to Logstash. We utilize the `swift-logging-elk` package, which provides a log handler that collects the logs and parses them to Logstash.

### Metrics

For the metrics we send the data to Prometheus. We utilize the `SwiftPrometheus` package, which handles the collecting and exporting of metrics. Due to the fact that Seeker is mainly intended for mobile applications, the pull-based approach, which is the standard for Prometheus doesn't really work. Mobile devices have limited resources by default (CPU, battery, etc.) and because of that, it doesn't make sense for them to receive and respond to requests. Thus in order to submit the data to prometheus, we make use of the [Prometheus Pushgateway](https://prometheus.io/docs/instrumenting/pushing/). 

### Traces

For the traces we send the data to Zipkin. We utilize the `opentelemetry-swift` package, which handles the collecting and exporting of metrics. Similiarly to Prometheus, Zipkin is also pull-based. To circumvent this, we make use of an [Opentelemetry-collector](https://github.com/open-telemetry/opentelemetry-collector), which stores the data for them to be then extracted by Zipkin.

## Setup

Seeker requires XCode 13.3 or Swift 5.6 toolchain with the Swift Package Manager.

Minimum targets: iOS 14 and macOS 10.15

### Swift Package Manager

Add `seeker` package as a dependency to your `Package.swift` file.

```swift
dependencies: [
    .package(url: "https://github.com/snkirov/seeker.git", from: "0.2.0")
]
```

Add the necessary prodcuts (from `Seeker`) to your target's dependencies.

```swift
targets: [
    .target(
        name: "ExampleApp",
        dependencies: [
            .product(name: "LoggingELK_Integration", package: "seeker"), // For example we want the LoggingELK_Integration product here
        ]
    )
]
```

### Default Configuration

The `Default Configuration` is the simplest way to setup the Seeker framework. Under the hood it sets up the LoggingELK logger, SwiftPrometheus metrics object and OpenTelemetry tracer. To do this, you need to add the `Default_Contfiguration` product to your project, then import it:

```swift
import Default_Configuration
```
Call the `setupDefaultConfiguration()` function on app launch, where you specify the host where the **Logstash**, **Prometheus PushGateway**, and **OTel Collector** instances are hosted. If using ports different than the default ones or the services are hosted on different hosts, there is also a more explicit version of this method.

```swift
// Default Configuration Setup
Seeker.setupDefaultConfiguration(host: "0.0.0.0")
```

### Logging Setup

Import the `LoggingELK_Integration` module:

```swift
import LoggingELK_Integration
```

Call the `setupLoggingELKLogger()` function on app launch, where you specify the host and port at which the **Logstash** instance is being ran.

```swift
// Logger Setup
Seeker.setupLoggingELKLogger(hostname: "0.0.0.0", port: 5000)
```

For a SwiftUI application - do it in the application `init()` method or in the `AppDelegate` `application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)` funtion for UIKit. 

**Important:** Using the logger without invoking a logger setup function will result in a crash.

#### Custom Logging Setup

If you want to use the logger with an observability framework different than logstash, you will need to add as a dependency and import Apple's [swift-log](https://github.com/apple/swift-log) package.

```swift
import Seeker
import Logging
import Customlogging
```

Then just bootstrap the logging system with a log handler of your choice as described [here](https://github.com/apple/swift-log#default-logger-behavior), create a logger and then call the `customLoggerSetup()` function.

```swift
LoggingSystem.bootstrap { label in
    MultiplexLogHandler(
        [
            CustomLogHandler(label: label)
        ]
    ) 
}

let logger = Logger("User_1")

Seeker.customLoggerSetup(for: logger)
```

**Important:** Using the logger without invoking a logger setup function will result in a crash.

### Metrics Setup

Import the `SwiftPrometheus_Integration` module:

```swift
import SwiftPrometheus_Integration
```

Call the `setupSwiftPrometheusMetrics()` function on app launch, where you specify the host and port at which the **Prometheus Pushgateway** instance is being ran.

```swift
// Metrics Setup
Seeker.setupSwiftPrometheusMetrics(hostname: "0.0.0.0", port: 9091)
```

For a SwiftUI application - do it in the application `init()` method or in the `AppDelegate` `application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)` funtion for UIKit. 

**Important:** Using the metrics interface without invoking the metrics setup function will result in a crash.

### Tracer Setup

Import the `Seeker` module:

```swift
import Seeker
```

Call the `setupOpenTelemetryTracer()` function on app launch, where you specify the host and port at which the **Opentelemetry collector** instance is being ran.

```swift
// Tracer Setup
Seeker.setupOpenTelemetryTracer()
```

**Important:** Using the tracer interface without invoking a tracer setup function will result in a crash.

#### Custom Tracer Setup

If you want to use the tracer with an observability framework different than Zipkin/ Jaeger, you will need to add as a dependency and import Apple's [swift-distributed-tracing](https://github.com/apple/swift-distributed-tracing) package.

```swift
import Seeker
import Tracing
import CustomTracing
```

Then just bootstrap the logging system with a log handler of your choice as described [here](https://github.com/apple/swift-log#default-logger-behavior), create a logger and then call the `customLoggerSetup()` function.

```swift
InstrumentationSystem.bootstrap(CustomTracing())

let tracer = InstrumentationSystem.tracer

Seeker.customTracerSetup(for: tracer)
```

**Important:** Using the tracer without invoking a tracer setup function will result in a crash.

## Usage

For example projects using this library see [seeker-swift-examples](https://github.com/snkirov/seeker-swift-examples).

### Logs

#### General Usage
Once setup, the logger interface can be easily accessed by importing the Seeker package and then accessing the `logger` property.

```swift
import Seeker
```

```swift
let logger = Seeker.logger
// Example logger usage
logger.log(level: .info, "Some sample log")
```

#### SwiftUI
When using SwiftUI the logger interface can be easily accessed by using the `@LoggerInstance` property wrapper.

```swift
import Seeker

struct SomeView: View {

    @LoggerInstance var logger
```

For details on how to use the Logging features of `apple/swift-log` exactly, please check out the [documentation of swift-log](https://github.com/apple/swift-log#readme).

### Metrics

#### General Usage
Once setup, the prometheus metrics interface can be easily accessed by importing the `SwiftPrometheus_Integration` product and then accessing the `promMetrics` property.

```swift
import SwiftPrometheus_Integration
```

```swift
let metrics = Seeker.promMetrics
// Example metrics usage
let counter = metrics.createCounter(forType: Int.self, named: "example_counter")
counter.inc()
```

#### SwiftUI
When using SwiftUI the prom metrics interface can be easily accessed by using the `@PromMetricsInstance` property wrapper.

```swift
import Seeker

struct SomeView: View {

    @PromMetricsInstance var metrics
```

For details on how to use the Metrics features of `swift-server-community/SwiftPrometheus` exactly, please check out the [documentation of SwiftPrometheus](https://github.com/swift-server-community/SwiftPrometheus#counter).

### Traces

#### General Usage
Once setup, the tracer interface can be easily accessed by importing the Seeker package and then accessing the `tracer` property. To generate a span event, you will need to add a dependency to and import `apple/swift-distributed-tracing`.

```swift
import Seeker
import Tracing
```

```swift
let tracer = Seeker.tracer
// Example tracer usage
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
```

#### SwiftUI
When using SwiftUI the tracer interface can be easily accessed by using the `@TracerInstance` property wrapper.

```swift
import Seeker

struct SomeView: View {

    @TracerInstance var tracer
```

For details on how to use the Traces features of `slashmo/opentelemetry-swift` exactly, please check out the [documentation of opentelemetry-swift](https://github.com/slashmo/opentelemetry-swift#starting-spans).

## Dependencies
- [swift-log-elk](https://github.com/Apodini/swift-log-elk) for logging
- [SwiftPrometheus](https://github.com/swift-server-community/SwiftPrometheus) for metrics
- [opentelemetry-swift](https://github.com/slashmo/opentelemetry-swift) for traces

## Documentation

Take a look at our [API reference](https://snkirov.github.io/seeker) for a full documentation of the package.

## Contributing
Contributions to this project are welcome. Please make sure to read the [contribution guidelines]() first.

## License
This project is licensed under the MIT License. See [License](https://github.com/snkirov/seeker/blob/master/LICENSE) for more information.
