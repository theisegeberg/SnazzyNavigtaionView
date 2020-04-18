import SwiftUI

protocol Navigating {
	associatedtype T: Identifiable
	func transition(_ view: T, edge: Edge)
	func unwind()
}
