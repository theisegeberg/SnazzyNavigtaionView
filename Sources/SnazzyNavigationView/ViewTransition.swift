import SwiftUI

struct ViewTransition<T: Identifiable> {
	let view: T
	var direction: Edge
	let unwoundDirection: Edge?
}
