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

import SwiftUI
import SnazzyNavigationView

enum ViewState: SnazzyState {
	case a, b(String), c
}

extension View {
	func eraseToAnyView() -> AnyView {
		return AnyView(self)
	}
}

struct ContentView: View {
	var body:some View {
		SnazzyNavigationView(initialState: ViewState.a) { (state, navigator) -> AnyView in
			switch state {
				case .a:
					let viewModel = ViewA.ViewModel(title: "x", navigating: navigator)
					return ViewA(model: viewModel).eraseToAnyView()
				case .b(let text):
					let viewModel = ViewB.ViewModel(title: text, navigating: navigator)
					return ViewB(model: viewModel).eraseToAnyView()
				case .c:
					let viewModel = ViewC.ViewModel(title: "X", navigating: navigator)
					return ViewC(model: viewModel).eraseToAnyView()
			}
		}
	}
}

struct ViewA: View {

	struct ViewModel {
		let title: String
		let navigating: AnyNavigator<ViewState>
	}

	var model: ViewModel

	var body: some View {
		VStack {

			Button(action: {
				withAnimation {
					self.model.navigating.transition(.b("Hello world"), edge: .trailing)
				}
			}) {
				Text(">>")
			}
			Button(action: {
				withAnimation {
					self.model.navigating.unwind()
				}
			}) {
				Text("unwind")
			}
			Color.red
		}.frame(maxWidth: .infinity)
	}
}

struct ViewB: View {

	struct ViewModel {
		let title: String
		let navigating: AnyNavigator<ViewState>
	}

	var model: ViewModel

	@State var someText = UUID().uuidString

	var body: some View {
		VStack {
			HStack {
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.a, edge: .leading)
					}
				}) {
					Text("<<")
				}

				Button(action: {
					self.model.navigating.transition(.b("Hullaballoo"), edge: .trailing)
				}) {
					Text("stay")
				}

				Button(action: {
					withAnimation {
						self.model.navigating.unwind()
					}
				}) {
					Text("unwind")
				}

				Button(action: {
					withAnimation {
						self.model.navigating.transition(.c, edge: .bottom)
					}
				}) {
					Text(">>")
				}
			}
			Button(action: {
				self.someText = UUID().uuidString
			}) {
				Text("change state")
			}
			Text(model.title)
			Text(self.someText)
			Color.orange
		}.frame(maxWidth: .infinity)

	}
}

struct ViewC: View {

	struct ViewModel {
		let title: String
		let navigating: AnyNavigator<ViewState>
	}

	var model: ViewModel

	var body: some View {

		VStack {
			Button(action: {
				withAnimation {
					self.model.navigating.transition(.b("From before"), edge: .leading)
				}
			}) {
				Text("<<")
			}

			Button(action: {
				withAnimation {
					self.model.navigating.transition(.a, edge: .trailing)
				}
			}) {
				Text(">>")
			}
			Button(action: {
				withAnimation {
					self.model.navigating.unwind(.upTo(2))
				}
			}) {
				Text("<<2")
			}
			Button(action: {
				withAnimation {
					self.model.navigating.unwind(.upTo(3))
				}
			}) {
				Text("<<3")
			}
			Button(action: {
				withAnimation {
					self.model.navigating.unwind()
				}
			}) {
				Text("unwind")
			}
			Color.blue
		}.frame(maxWidth: .infinity)
	}
}




```

## Authors

* **Theis Egeberg** - (https://github.com/theisegeberg)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Jonathan McAllister [https://github.com/Joony](https://github.com/Joony), for providing most of the inpsiration for the resolver pattern, and for teaching me the mindset of a programmer.
* Srđan Rašić [https://github.com/srdanrasic](https://github.com/srdanrasic), for the foundational patterns used in this.
