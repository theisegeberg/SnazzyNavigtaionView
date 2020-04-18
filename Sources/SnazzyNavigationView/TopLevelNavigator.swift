import SwiftUI

public class TopLevelNavigator<T:Identifiable>:ObservableObject,Navigating {
	
	typealias TransitionType = ViewTransition<T>
	
	var history:[TransitionType]
	
	@Published var currentTransition:TransitionType
	
	init(_ initialTransition:TransitionType) {
		self.history = [initialTransition]
		self.currentTransition = initialTransition
	}
	
	func transition(_ transition:TransitionType) {
		self.history.append(transition)
		self.currentTransition = transition
	}
	
	public func transition(_ view:T,edge:Edge) {
		self.transition(ViewTransition(view: view, direction: edge, unwoundDirection: nil))
	}
	
	public func unwind() {
		guard history.count > 1 else {
			return
		}
		
		let current = history.popLast()!
		let previous = history.popLast()!
		
		let state = previous.view
		let direction:Edge
		if let unwoundDirection = current.unwoundDirection {
			direction = unwoundDirection
		} else {
			direction = current.direction
		}
		
		self.transition(ViewTransition(view: state, direction: direction.opposing, unwoundDirection: previous.direction))
	}
	
}
