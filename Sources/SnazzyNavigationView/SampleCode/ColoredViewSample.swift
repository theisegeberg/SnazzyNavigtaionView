
import SwiftUI

enum ViewState: SnazzyState {
	//	First off we define each of our states. The state must implement the SnazzyState protocol. Some magic goes on behind the scenes here, but basically it's just to be able to identify views and states uniquely. In this case we'll just make a state for each of our views, but you're not limited to that.
	case red, orange(String), blue, purple, gray, pink
}

extension View {
	//	This is just a helper function, how long till this is incporporated into SwiftUI I wonder?
	func eraseToAnyView() -> AnyView {
		return AnyView(self)
	}
}

struct ContentView: View {
	var body:some View {
		//		Throw in the navigation view as you would any other SwiftUI view. You can also pass in the navigator from the outside. If you don't it will instantiate a SnazzyNavigator for you that gets passed into the state resolving closure.
		SnazzyNavigationView(initialState: ViewState.red) { (state, navigator) -> AnyView in
			//			In here return an AnyView as you please. This view will be navigated to.
			switch state {
				case .red:
					let viewModel = Red.ViewModel(navigating: navigator)
					return Red(model: viewModel).eraseToAnyView()
				case .orange(let text):
					//					We parse in variables from the unresolved state to the model!
					let viewModel = Orange.ViewModel(title: text, navigating: navigator)
					return Orange(model: viewModel).eraseToAnyView()
				case .blue:
					//					Views can have different models!
					let viewModel = Blue.ViewModel(navigating: navigator)
					return Blue(model: viewModel).eraseToAnyView()
				case .purple:
					let viewModel = Purple.ViewModel(navigating: navigator)
					return Purple(model: viewModel).eraseToAnyView()
				case .gray:
					//					Some views don't even have models?!
					return MultipColorView(unwind: navigator.unwind, color: Color.gray).eraseToAnyView()
				case .pink:
					//					Wow, you can use the same view again and again! The possibilities are endless
					return MultipColorView(unwind: navigator.unwind, color: Color.pink).eraseToAnyView()
			}
		}
	}
}

struct Red: View {
	
	struct ViewModel {
		let navigating: SnazzyNavigator<ViewState>
	}
	
	var model: ViewModel
	
	var body: some View {
		VStack {
			
			HStack {
				Button(action: {
					withAnimation {
						self.model.navigating.unwind()
					}
				}) {
					Image(systemName: "chevron.left")
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.pink, edge: .top)
					}
				}) {
					Text("Pink ↑")
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.orange("I came from red!"), edge: .trailing)
					}
				}) {
					Text("Orange →")
				}
			}
			.padding(10)
			Color.red
		}
	}
}

struct Orange: View {
	
	struct ViewModel {
		let title: String
		let navigating: SnazzyNavigator<ViewState>
	}
	
	var model: ViewModel
	
	var body: some View {
		VStack {
			HStack {
				
				Button(action: {
					withAnimation {
						self.model.navigating.unwind()
					}
				}) {
					Image(systemName: "chevron.left")
				}
				
				Spacer()
				
				VStack {
					Button(action: {
						withAnimation {
							self.model.navigating.transition(.gray, edge: .top)
						}
					}) {
						Text("Gray ↑")
					}
					
					Button(action: {
						withAnimation {
							self.model.navigating.transition(.purple, edge: .bottom)
						}
					}) {
						Text("Purple ↓")
					}
					
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.blue, edge: .trailing)
					}
				}) {
					Text("Blue →")
				}
			}
			.padding(10)
			Text(model.title)
			Color.orange
		}
		
	}
}

struct Blue: View {
	
	struct ViewModel {
		let navigating: SnazzyNavigator<ViewState>
	}
	
	var model: ViewModel
	
	var body: some View {
		
		VStack {
			HStack {
				
				Button(action: {
					withAnimation {
						self.model.navigating.unwind()
					}
				}) {
					Image(systemName: "chevron.left")
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.red, edge: .trailing)
					}
				}) {
					Text("Red →")
				}
			}
			.padding(10)
			Color.blue
		}
	}
}

struct MultipColorView: View {
	
	var unwind:()->()
	var color:Color
	
	var body: some View {
		
		VStack {
			HStack {
				
				Button(action: {
					withAnimation {
						self.unwind()
					}
				}) {
					Image(systemName: "chevron.left")
				}
				
				Spacer()
				
				
			}
			.padding(10)
			self.color
		}
	}
}



struct Purple: View {
	
	struct ViewModel {
		let navigating: SnazzyNavigator<ViewState>
	}
	
	var model: ViewModel
	
	var body: some View {
		
		VStack {
			HStack {
				
				Button(action: {
					withAnimation {
						self.model.navigating.unwind()
					}
				}) {
					Image(systemName: "chevron.left")
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.unwind(.root)
					}
				}) {
					Text("Pop all views")
				}
				
				Spacer()
				
				Button(action: {
					withAnimation {
						self.model.navigating.transition(.orange("I came from purple!"), edge: .leading)
					}
				}) {
					Text("← Orange")
				}
			}
			.padding(10)
			Color.purple
		}
	}
}
