# SnazzyNavigationView

Based on SwiftUI this view handles navigation between views in a simple and appeasing way. It does not build on top of the NavigationView but is pure SwiftUI magic.

## Getting Started

### Prerequisites

- iOS 13.0+ / macOS 10.15+ 
- Xcode 11+
- Swift 5.2+

### Installing

#### In Xcode
Open an iOS or MacOS project in Xcode and go to:
`File -> Swift Packages -> Add Package Dependency...`
There copy the repo url in the text field:
`https://github.com/theisegeberg/SnazzyNavigtaionView.git`

#### In Package.swift
Manually add to the `dependencies` in `Package.swift`...

```swift
dependencies: [
.package(url: "https://github.com/theisegeberg/SnazzyNavigtaionView.git", .upToNextMajor(from: "0.1.0"))
]
```

## Quick start

```swift



```

## Authors

* **Theis Egeberg** - (https://github.com/theisegeberg)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Jonathan McAllister [https://github.com/Joony](https://github.com/Joony), for providing most of the inpsiration for the resolver pattern, and for teaching me the mindset of a programmer.
* Srđan Rašić [https://github.com/srdanrasic](https://github.com/srdanrasic), for the foundational patterns used in this.
