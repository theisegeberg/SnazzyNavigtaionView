import SwiftUI

struct OpacityModifier: ViewModifier {
	
	var opacity:Double = 1.0
	
	init(_ opacity:Double) {
		self.opacity = opacity
	}
	
	func body(content: Content) -> some View {
		content.opacity(opacity)
	}
}

struct OpposingMoveTransitionModifier: ViewModifier {

	@Binding var type: TransitionType

	func body(content: Content) -> some View {
		switch type {
			case .edge(let edge):
				return content.transition(AnyTransition.asymmetric(insertion: .move(edge: edge), removal: .move(edge: edge.opposing)))
			case let .opacity(start, end):
				return content.transition(AnyTransition.modifier(active: OpacityModifier(start), identity: OpacityModifier(1)))
			case .none:
				return content.transition(AnyTransition.identity)
		}
	}
}
