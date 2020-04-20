import SwiftUI

public indirect enum TransitionType {
	case
	edge(Edge),
	opacity(Double,Double),
	none
	
	var opposing:TransitionType {
		switch self {
			case .edge(let edge):
				return .edge(edge.opposing)
			case let .opacity(start, end):
				return .opacity(end, start)
			case .none:
				return .none
		}
	}
	
}
