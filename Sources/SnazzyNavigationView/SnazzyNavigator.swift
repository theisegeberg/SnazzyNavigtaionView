import SwiftUI

public class SnazzyNavigator<NavigatableState: SnazzyState>: ObservableObject {

	typealias T = ViewTransition<NavigatableState>

	var history: [T]

	@Published var currentTransition: T

	public var currentState: NavigatableState {
		return self.currentTransition.view
	}

	public convenience init(view initialView: NavigatableState) {
		self.init(view: initialView, type: .edge(.leading))
	}

	public init(view initialView: NavigatableState, type: TransitionType) {
		let initialTransition = T(view: initialView, type: type)
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
		self.transition(ViewTransition(view: view, type: .edge(edge)), clearHistory: clearHistory)
	}

	public func transition(_ view: NavigatableState, type: TransitionType, clearHistory: Bool = false) {
		self.transition(ViewTransition(view: view, type: type), clearHistory: clearHistory)
	}

	public func unwind() {
		self.unwind(.one)
	}

	public func unwind(_ distance: UnwindDistance) {

		guard history.count > 1 else {
			return
		}

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

				let targetTransition = history[targetIndex]
				let current = history.last!

				history = Array(history[0..<targetIndex + 1])

				self.currentTransition = ViewTransition(view: targetTransition.view, type: current.type.opposing)
		}

	}

	public func canUnwind() -> Bool {
		return (history.count > 1)
	}

}

public extension SnazzyNavigator where NavigatableState: CaseIterable, NavigatableState: Equatable {

	func next() {
		self.transition(self.currentTransition.view.next, type: self.currentTransition.type)
	}

}
