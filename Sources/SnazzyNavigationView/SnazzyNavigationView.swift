import SwiftUI

public struct SnazzyNavigationView<T:Identifiable>: View {
	
	public typealias ResolverType = (T,TopLevelNavigator<T>)->AnyView
	
	@ObservedObject var navigator:TopLevelNavigator<T>
	
	let resolver:ResolverType
	
	public init(initialState:T, _ resolver:@escaping ResolverType) {
		self.resolver = resolver
		self.navigator = TopLevelNavigator<T>(ViewTransition(view: initialState, direction: .leading, unwoundDirection: nil))
	}
	
	func getView(_ state:T) -> AnyView {
		return resolver(state,self.navigator)
	}
	
	public var body: some View {
		VStack {
			Group {
				getView(self.navigator.currentTransition.view)
			}.modifier(OpposingMoveTransitionModifier(edge: self.$navigator.currentTransition.direction))
		}
		
	}
}
