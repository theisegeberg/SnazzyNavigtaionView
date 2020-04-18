import SwiftUI

public protocol SnazzyState: Identifiable {
	var id: Int { get }
}

public extension SnazzyState {
	var id: Int {
		return String(describing: self).hashValue
	}
}

public struct SnazzyNavigationView<T: SnazzyState>: View {

	public typealias ResolverType = (T, AnyNavigator<T>) -> AnyView

	@ObservedObject var navigator: SnazzyNavigator<T>

	let resolver: ResolverType

	public init(initialState: T, _ resolver:@escaping ResolverType) {
		self.resolver = resolver
		let navigator = SnazzyNavigator(view: initialState)
		self.navigator = navigator
	}

	func getView(_ state: T) -> AnyView {
		return resolver(state, self.navigator.eraseToAnyNavigator())
	}

	public var body: some View {
		VStack {
			getView(self.navigator.currentTransition.view).id(self.navigator.currentTransition.view.id)
				.modifier(OpposingMoveTransitionModifier(edge: self.$navigator.currentTransition.edge))
		}
	}
}
