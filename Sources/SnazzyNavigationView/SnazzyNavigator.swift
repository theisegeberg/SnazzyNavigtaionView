import SwiftUI

public class SnazzyNavigator<NavigatableState: SnazzyState>: ObservableObject {

	typealias T = ViewTransition<NavigatableState>

	var history: [T]

	@Published var currentTransition: T

	public init(view initialView: NavigatableState) {
		let initialTransition = T(view: initialView, type: .none, unwindType: nil)
		self.history = [initialTransition]
		self.currentTransition = initialTransition
	}

	func transition(_ transition: T, clearHistory: Bool) {
		if clearHistory {
			self.history = [transition]
		} else {
			self.history.append(transition)
		}
		self.currentTransition = transition
	}

	public func transition(_ view: NavigatableState, edge: Edge) {
		self.transition(view, edge: edge, clearHistory: false)
	}

	public func transition(_ view: NavigatableState, edge: Edge, clearHistory: Bool) {
		self.transition(ViewTransition(view: view, type: .edge(edge), unwindType: nil), clearHistory: clearHistory)
	}
	
	public func transition(_ view: NavigatableState, type: TransitionType, clearHistory: Bool = false) {
		self.transition(ViewTransition(view: view, type: type, unwindType: nil), clearHistory: clearHistory)
	}

	public func unwind() {
		self.unwind(.one)
	}

	public func unwind(_ distance: UnwindDistance) {

		guard history.count > 1 else {
			return
		}

		let targetTransition: ViewTransition<NavigatableState>

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

				targetTransition = history[targetIndex]
				let current = history.last!

				history = Array(history[0..<targetIndex])

				let targetView = targetTransition.view
				
				let nextTransitionType: TransitionType
				let unwindTransitionType: TransitionType

				if let unwindType = current.unwindType {
					nextTransitionType = unwindType
					unwindTransitionType = unwindType
				} else {
					nextTransitionType = current.type
					unwindTransitionType = targetTransition.type
				}

				self.transition(ViewTransition(view: targetView, type: nextTransitionType.opposing, unwindType: unwindTransitionType), clearHistory: false)
		}

	}

	public func canUnwind() -> Bool {
		return (history.count > 1)
	}

}
