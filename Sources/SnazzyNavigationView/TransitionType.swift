import SwiftUI

public indirect enum TransitionType {
	case
	edge(Edge),
	opacity,
	none

	var opposing: TransitionType {
		switch self {
			case .edge(let edge):
				return .edge(edge.opposing)
			case .opacity:
				return .opacity
			case .none:
				return .none
		}
	}

}
