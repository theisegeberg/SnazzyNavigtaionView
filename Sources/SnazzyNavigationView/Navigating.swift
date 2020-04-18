import SwiftUI

public enum UnwindDistance {
	case one, upTo(Int), root
}

public protocol Navigating: ObservableObject {

	associatedtype NavigatableState: SnazzyState

	func transition(_ view: NavigatableState, edge: Edge)
	func transition(_ view: NavigatableState, edge: Edge, clearHistory: Bool)
	func unwind()
	func unwind(_ distance: UnwindDistance)
	func canUnwind() -> Bool

}
