import SwiftUI

public protocol SnazzyState: Identifiable {
	var id: Int { get }
}

public extension SnazzyState {
	var id: Int {
		return String(describing: self).hashValue
	}
}

public struct SnazzyNavigationView<NavigatableState: SnazzyState>: View {

	public typealias ResolverType = (NavigatableState, AnyNavigator<NavigatableState>) -> AnyView

	@ObservedObject var navigator: SnazzyNavigator<NavigatableState>

	let resolver: ResolverType

	public init(initialState: NavigatableState, _ resolver:@escaping ResolverType) {
		self.resolver = resolver
		let navigator = SnazzyNavigator(view: initialState)
		self.navigator = navigator
	}
	
	public init<N:Navigating>(initialState: NavigatableState, navigator:N, _ resolver:@escaping ResolverType) where N.NavigatableState == NavigatableState {
		self.resolver = resolver
		let navigator = SnazzyNavigator(view: initialState)
		self.navigator = navigator
	}
	

	func getView(_ state: NavigatableState) -> AnyView {
		return resolver(state, self.navigator.eraseToAnyNavigator())
	}

	public var body: some View {
		VStack {
			getView(self.navigator.currentTransition.view).id(self.navigator.currentTransition.view.id)
				.modifier(OpposingMoveTransitionModifier(edge: self.$navigator.currentTransition.edge))
		}
	}
}
