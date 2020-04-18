import SwiftUI

public class TopLevelNavigator<T: Identifiable>: ObservableObject, Navigating {

	public typealias TransitionType = ViewTransition<T>

	var history: [TransitionType]

	@Published public var currentTransition: TransitionType

	public var currentView: T {
		return self.history.first!.view
	}

	required public init(view initialView: T) {
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

	public func transition(_ view: T, edge: Edge, clearHistory: Bool) {
		self.transition(ViewTransition(view: view, edge: edge, unwoundEdge: nil), clearHistory: clearHistory)
	}

	public func transition(_ view: T, edge: Edge) {
		self.transition(view, edge: edge, clearHistory: false)
	}

	public func unwind() {
		self.unwind(.one)
	}

	public func unwind(_ distance: UnwindDistance) {

		guard history.count > 1 else {
			return
		}

		let target: ViewTransition<T>

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
