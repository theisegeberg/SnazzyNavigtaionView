import SwiftUI

public struct ViewTransition<T: SnazzyState> {
	let view: T
	var type: TransitionType
}
