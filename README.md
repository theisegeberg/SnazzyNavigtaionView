# SnazzyNavigationView

Based on SwiftUI this view handles navigation between views in a simple and appeasing way. It does not build on top of the NavigationView but is pure SwiftUI magic.

[Example](https://i.imgur.com/0UuDX4Z.gif)

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

**Full sample code with helpful commentary: [SampleCode/ColoredViewSample.swift](Sources/SnazzyNavigationView/SampleCode/ColoredViewSample.swift)**

1. Import SwiftUI and SnazzyNavigationView
```swift
import SwiftUI
import SnazzyNavigationView
```

2. First off we'll define our states. These are the things Snazzy navigates between. The easiest way is just to use an enum, but you can really use anything that implements `SnazzyState`. In this case we'll do a range of colors that corresponds to the views we'll show later.
```swift
enum ViewState: SnazzyState {
	case red, orange(String), blue, purple, gray, pink
}
```



3. We'll add the `eraseToAnyView` helper function on View. Then we'll create `ContentView` to hold our `SnazzyNavigationView`. The initializer will take a resolver that turns a `SnazzyState` (the `ViewState` from just above) into an `AnyView`. This example is pretty linear. Almost all states have a dedicated view, except for `gray` and `pink` which reuses the same view.  Most views have a dedicated `ViewModel` but that's not required. For most apps though, it's recommended to send information through the state into the viewmodel and then into the view. If you need to access the navigator from outside of the navigation view, you can pass in a `SnazzyNavigator` into the `SnazzyNavigationView` initiliazer.
```swift
extension View {
	//	This is just a helper function, how long till this is incporporated into SwiftUI I wonder?
	func eraseToAnyView() -> AnyView {
		return AnyView(self)
	}
}

struct ContentView: View {
	var body:some View {
		// Throw in the navigation view as you would any other SwiftUI view. You can also pass in the navigator from the outside. If you don't it will instantiate a SnazzyNavigator for you that gets passed into the state resolving closure.
		SnazzyNavigationView(initialState: ViewState.red) { (state, navigator) -> AnyView in
			// In here return an AnyView as you please. This view will be navigated to.
			switch state {
				case .red:
					let viewModel = Red.ViewModel(navigating: navigator)
					return Red(model: viewModel).eraseToAnyView()
				case .orange(let text):
					// We parse in variables from the unresolved state to the model!
					let viewModel = Orange.ViewModel(title: text, navigating: navigator)
					return Orange(model: viewModel).eraseToAnyView()
				case .blue:
					// Views can have different models!
					let viewModel = Blue.ViewModel(navigating: navigator)
					return Blue(model: viewModel).eraseToAnyView()
				case .purple:
					let viewModel = Purple.ViewModel(navigating: navigator)
					return Purple(model: viewModel).eraseToAnyView()
				case .gray:
					// Some views don't even have models?!
					return MultipColorView(unwind: navigator.unwind, color: Color.gray).eraseToAnyView()
				case .pink:
					// Wow, you can use the same view again and again! The possibilities are endless
					return MultipColorView(unwind: navigator.unwind, color: Color.pink).eraseToAnyView()
			}
		}
	}
}
```

Here's what a view looks like. No magic here, the rest of the views code can be found in the sample code linked to aboce.
```swift
struct Red: View {
	
	struct ViewModel {
		let navigating: AnyNavigator<ViewState>
	}
	
	var model: ViewModel
	
	var body: some View {
		VStack {
			
			HStack {
				Button(action: {
					withAnimation {
						self.model.navigating.unwind()
					}
				}) {
					Image(systemName: "chevron.left")
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.pink, edge: .top)
					}
				}) {
					Text("Pink ↑")
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.orange("I came from red!"), edge: .trailing)
					}
				}) {
					Text("Orange →")
				}
			}
			.padding(10)
			Color.red
		}
	}
}
```

## Authors

* **Theis Egeberg** - (https://github.com/theisegeberg)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Jonathan McAllister [https://github.com/Joony](https://github.com/Joony), for providing most of the inpsiration for the resolver pattern, and for teaching me the mindset of a programmer.
* Srđan Rašić [https://github.com/srdanrasic](https://github.com/srdanrasic), for the inspiration from the binder pattern that this mimics to some extent.
