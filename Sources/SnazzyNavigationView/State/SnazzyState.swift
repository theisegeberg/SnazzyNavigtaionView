import SwiftUI

public protocol SnazzyState: Identifiable, Equatable {
	var id: Int { get }
}

extension Collection {
	func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

public extension SnazzyState where Self: Equatable, Self: CaseIterable {

	var isLast: Bool {
		return index == Self.allCases.index(Self.allCases.endIndex, offsetBy: -1)
	}

	var isFirst: Bool {
		return index == Self.allCases.startIndex
	}

	var next: Self {
		let index = self.index
		if self.isLast {
			return self
		}
		return Self.allCases[Self.allCases.index(index, offsetBy: 1)]
	}

	var previous: Self {
		let index = self.index
		if self.isFirst {
			return self
		}
		return Self.allCases[Self.allCases.index(index, offsetBy: -1)]
	}

	var nextCyclic: Self {
		let index = self.index
		guard index < Self.allCases.index(Self.allCases.endIndex, offsetBy: -1) else {
			return Self.allCases[Self.allCases.startIndex]
		}
		return Self.allCases[Self.allCases.index(index, offsetBy: 1)]
	}

	var previousCyclic: Self {
		let index = self.index
		guard index != Self.allCases.startIndex else {
			return Self.allCases[Self.allCases.startIndex]
		}
		return Self.allCases[Self.allCases.index(index, offsetBy: -1)]
	}

	var index: Self.AllCases.Index {
		guard let index = Self.allCases.firstIndex(where: { (value) -> Bool in
			return value == self
		}) else {
			fatalError()
		}
		return index
	}

	var indexAsInt: Int {
		return Self.allCases.distance(to: self.index)
	}

	static var count: Int {
		return Self.allCases.count
	}
}

public extension SnazzyState {
	var id: Int {
		return String(describing: self).hashValue
	}
}
