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

## Description

### Logging

For the logging we send the data to Logstash. We utilize the `swift-logging-elk` package, which provides a log handler that collects the logs and parses them to Logstash.

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
    .package(url: "https://github.com/snkirov/seeker.git", from: "0.1.0")
]
```

Add `Seeker` (from `seeker`) to your target's dependencies.

```swift
targets: [
    .target(
        name: "ExampleApp",
        dependencies: [
            .product(name: "Seeker", package: "seeker"),
        ]
    )
]
```

### Setup Logging

Import the `Seeker` module:

```swift
import Seeker
```

Call the `loggerSetup()` function on app launch, where you specify the host and port at which the **Logstash** instance is being ran.

```swift
// Logger Setup
Seeker.loggerSetup(hostname: "0.0.0.0", port: 5000)
```

For a SwiftUI application - do it in the application `init()` method or in the `AppDelegate` `application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)` funtion for UIKit. 

**Important:** Using the logger without invoking a logger setup function will result in a crash.

#### Custom Logging Setup

If you want to use the logger with an observability framework different than logstash, you will need to add as a dependency and import Apple's [swift-log](https://github.com/apple/swift-log) package.

```swift
import Seeker
import Logging
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

### Setup Metrics

Import the `Seeker` module:

```swift
import Seeker
```

Call the `metricsSetup()` function on app launch, where you specify the host and port at which the **Prometheus Pushgateway** instance is being ran.

```swift
// Metrics Setup
Seeker.metricsSetup(hostname: "0.0.0.0", port: 9091)
```

For a SwiftUI application - do it in the application `init()` method or in the `AppDelegate` `application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)` funtion for UIKit. 

**Important:** Using the metrics interface without invoking the metrics setup function will result in a crash.

### Setup Traces

Import the `Seeker` module:

```swift
import Seeker
```

Call the `tracerSetup()` function on app launch, where you specify the host and port at which the **Opentelemetry collector** instance is being ran.

```swift
// Tracer Setup
Seeker.tracerSetup()
```

**Important:** Using the tracer interface without invoking a tracer setup function will result in a crash.

#### Custom Tracer Setup

If you want to use the tracer with an observability framework different than Zipkin/ Jaeger, you will need to add as a dependency and import Apple's [swift-distributed-tracing](https://github.com/apple/swift-distributed-tracing) package.

```swift
import Seeker
import Tracing
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

let tracer = Logger("User_1")

Seeker.customTracerSetup(for: tracer)
```

**Important:** Using the tracer without invoking a tracer setup function will result in a crash.

## Dependencies
- [swift-log-elk](https://github.com/Apodini/swift-log-elk) for logging
- [SwiftPrometheus](https://github.com/swift-server-community/SwiftPrometheus) for metrics
- [opentelemetry-swift](https://github.com/slashmo/opentelemetry-swift) for traces
