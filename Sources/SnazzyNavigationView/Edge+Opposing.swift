import SwiftUI

extension Edge {
	var opposing:Edge {
		switch self {
			case .bottom:
				return .top
			case .top:
				return .bottom
			case .leading:
				return .trailing
			case .trailing:
				return .leading
		}
	}
}
