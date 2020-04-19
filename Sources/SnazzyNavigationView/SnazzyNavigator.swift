import SwiftUI

public class SnazzyNavigator<NavigatableState: SnazzyState>: ObservableObject {

	typealias TransitionType = ViewTransition<NavigatableState>

	var history: [TransitionType]

	@Published var currentTransition: TransitionType

	init(view initialView: NavigatableState) {
		let initialTransition = TransitionType(view: initialView, edge: .leading, unwoundEdge: nil)
		self.history = [initialTransition]
		self.currentTransition = initialTransition
	}

	func transition(_ transition: TransitionType, clearHistory: Bool) {
		if clearHistory {
			self.history = [transition]
		} else {
			self.history.append(transition)
		}
		self.currentTransition = transition
	}

	public func transition(_ view: NavigatableState, edge: Edge, clearHistory: Bool) {
		self.transition(ViewTransition(view: view, edge: edge, unwoundEdge: nil), clearHistory: clearHistory)
	}

	public func transition(_ view: NavigatableState, edge: Edge) {
		self.transition(view, edge: edge, clearHistory: false)
	}

	public func unwind() {
		self.unwind(.one)
	}

	public func unwind(_ distance: UnwindDistance) {

		guard history.count > 1 else {
			return
		}

		let target: ViewTransition<NavigatableState>

		switch distance {
			case .one:
				self.unwind(.upTo(1))
				return
			case .root:
				self.unwind(.upTo(self.history.count))
			case .upTo(let goBackToIndex):
				let targetIndex: Int

				if history.count > goBackToIndex {
					targetIndex = history.count - goBackToIndex - 1
				} else {
					targetIndex = 0
				}

				target = history[targetIndex]
				let current = history.last!

				history = Array(history[0..<targetIndex])

				let state = target.view
				let edge: Edge
				if let unwoundEdge = current.unwoundEdge {
					edge = unwoundEdge
				} else {
					edge = current.edge
				}

				self.transition(ViewTransition(view: state, edge: edge.opposing, unwoundEdge: target.edge), clearHistory: false)
		}

	}

	public func canUnwind() -> Bool {
		return (history.count > 1)
	}

}
