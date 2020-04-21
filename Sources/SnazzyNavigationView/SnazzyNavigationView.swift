import SwiftUI

public struct SnazzyNavigationView<NavigatableState: SnazzyState>: View {

	public typealias ResolverType = (NavigatableState, SnazzyNavigator<NavigatableState>) -> AnyView

	@ObservedObject var navigator: SnazzyNavigator<NavigatableState>

	let resolver: ResolverType

	public init(initialState: NavigatableState, _ resolver:@escaping ResolverType) {
		self.init(navigator: SnazzyNavigator(view: initialState), resolver)
	}

	public init(navigator: SnazzyNavigator<NavigatableState>, _ resolver:@escaping ResolverType) {
		self.resolver = resolver
		self.navigator = navigator
	}

	func getView(_ state: NavigatableState) -> AnyView {
		return resolver(state, self.navigator)
	}

	public var body: some View {
		VStack {
			getView(self.navigator.currentTransition.view)
				.id(self.navigator.currentTransition.view.id)
				.modifier(OpposingMoveTransitionModifier(type: self.$navigator.currentTransition.type))
		}
	}
}
