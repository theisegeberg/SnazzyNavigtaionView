import SwiftUI

public struct ViewTransition<T: Identifiable> {
	let view: T
	var edge: Edge
	let unwoundEdge: Edge?
}
