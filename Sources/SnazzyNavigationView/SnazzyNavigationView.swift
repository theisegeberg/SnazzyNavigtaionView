import SwiftUI

public struct SnazzyNavigationView<T, Navigator: Navigating>: View where Navigator.NavigatableState == T {

	public typealias ResolverType = (T, Navigator) -> AnyView

	@ObservedObject var navigator: Navigator

	let resolver: ResolverType

	public init(initialState: T, _ resolver:@escaping ResolverType) {
		self.resolver = resolver
		self.navigator = Navigator(view: initialState)
	}

	func getView(_ state: T) -> AnyView {
		return resolver(state, self.navigator)
	}

	public var body: some View {
		VStack {
			getView(self.navigator.currentTransition.view)
				.modifier(OpposingMoveTransitionModifier(edge: self.$navigator.currentTransition.edge))
		}

	}
}
