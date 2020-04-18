import SwiftUI

struct OpposingMoveTransitionModifier: ViewModifier {

	@Binding var edge: Edge

	func body(content: Content) -> some View {
		content.transition(AnyTransition.asymmetric(insertion: .move(edge: self.edge), removal: .move(edge: self.edge.opposing)))
	}
}
