import SwiftUI

public struct ViewTransition<T: SnazzyState> {
	let view: T
	var edge: Edge
	let unwoundEdge: Edge?
}
