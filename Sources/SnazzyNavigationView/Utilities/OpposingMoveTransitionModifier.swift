import SwiftUI

struct OpposingMoveTransitionModifier: ViewModifier {

	@Binding var type: TransitionType

	func body(content: Content) -> some View {
		switch type {
			case .edge(let edge):
				return content.transition(.asymmetric(insertion: .move(edge: edge), removal: .move(edge: edge.opposing)))
			case .opacity:
				return content.transition(.opacity)
			case .none:
				return content.transition(.identity)
		}
	}
}
