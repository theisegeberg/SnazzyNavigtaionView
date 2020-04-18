import SwiftUI

extension Navigating {
	func eraseToAnyNavigator() -> AnyNavigator<NavigatableState> {
		return AnyNavigator(self)
	}
}

public struct AnyNavigator<NavigatableState: SnazzyState> {

	let _transition: (NavigatableState, Edge) -> Void
	let _transitionClearHistory: (NavigatableState, Edge, Bool) -> Void
	let _unwind:() -> Void
	let _unwindDistance: (UnwindDistance) -> Void
	let _canUnwind: () -> Bool

	init<Navigator: Navigating>(_ navigator: Navigator) where Navigator.NavigatableState == NavigatableState {
		self._transition = navigator.transition
		self._transitionClearHistory = navigator.transition
		self._unwind = navigator.unwind
		self._unwindDistance = navigator.unwind
		self._canUnwind = navigator.canUnwind
	}

	public func transition(_ view: NavigatableState, edge: Edge) {
		self._transition(view, edge)
	}
	public func transition(_ view: NavigatableState, edge: Edge, clearHistory: Bool) {
		self._transitionClearHistory(view, edge, clearHistory)
	}
	public func unwind() {
		self._unwind()
	}
	public func unwind(_ distance: UnwindDistance) {
		self._unwindDistance(distance)
	}
	public func canUnwind() -> Bool {
		return self._canUnwind()
	}

}
