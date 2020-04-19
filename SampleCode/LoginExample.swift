import SwiftUI
import Combine
import SnazzyNavigationView

struct UserDatabase {
	func isUserValid(username: String, password: String) -> Bool {
		return username.count + password.count > 0
	}
}

struct LoginToken {
	let username: String
	let eMails: [String]
}

enum ViewState: SnazzyState {
	case intro, guide, login, mailbox(LoginToken), error(String)
}

extension View {
	func eraseToAnyView() -> AnyView {
		return AnyView(self)
	}
}

struct CanLogOutKey: PreferenceKey {
	static var defaultValue: Bool = false
	
	static func reduce(value: inout Bool, nextValue: () -> Bool) {
		value = nextValue()
	}
}

struct LocalNavigationBarTitleKey: PreferenceKey {
	static var defaultValue: String = ""
	
	static func reduce(value: inout String, nextValue: () -> String) {
		value = nextValue()
	}
}

extension View {
	func navigationBarTitle(_ title: String) -> some View {
		self.preference(key: LocalNavigationBarTitleKey.self, value: title)
	}
}

struct ContentView: View {
	
	@State var title: String = "-"
	@State var canLogOut: Bool = false
	
	let navigator = SnazzyNavigator(view: ViewState.intro)
	
	func getView(state: ViewState, navigator: SnazzyNavigator<ViewState>) -> AnyView {
		switch state {
			case .intro:
				return IntroView(navigator: navigator).eraseToAnyView()
			case .guide:
				return GuideView().eraseToAnyView()
			case .error(let errorDescription):
				return ErrorView(errorDescription: errorDescription).eraseToAnyView()
			case .login:
				return LoginView(session: LoginView.LoginSession(UserDatabase()), navigator: navigator).eraseToAnyView()
			case .mailbox(let token):
				return MailBoxView(token: token).eraseToAnyView()
		}
	}
	
	var body: some View {
		VStack {
			ZStack {
				HStack {
					if self.navigator.canUnwind() {
						Button(action: {
							withAnimation {
								self.navigator.unwind()
							}
						}) {
							Image(systemName: "chevron.left")
						}.transition(.move(edge: .leading))
					}
					
					Spacer()
					
					if self.canLogOut {
						Button(action: {
							withAnimation {
								self.navigator.transition(.intro, edge: .leading, clearHistory: true)
							}
						}) {
							Text("Logout")
						}.transition(.move(edge: .trailing))
					}
					
				}
				Text(self.title).id(self.title.hashValue).transition(.opacity).font(Font.system(.title))
				
			}
			.padding(10)
			SnazzyNavigationView(navigator: navigator, self.getView)
				.onPreferenceChange(LocalNavigationBarTitleKey.self) { (title) in
					withAnimation {
						self.title = title
					}
			}
			.onPreferenceChange(CanLogOutKey.self) { (canLogOut) in
				self.canLogOut = canLogOut
			}
		}
	}
}

struct IntroView: View {
	
	let navigator: SnazzyNavigator<ViewState>
	
	var body: some View {
		ZStack {
			Color.blue
			VStack(spacing:10) {
				Button(action: {
					withAnimation {
						self.navigator.transition(.login, edge: .trailing)
					}
				}) {
					Text("Go to login").padding(10).background(RoundedRectangle(cornerRadius: 5).fill(Color.white)).foregroundColor(Color.blue)
				}
				Button(action: {
					withAnimation {
						self.navigator.transition(.guide, edge: .trailing)
					}
				}) {
					Text("Show the guide").padding(10).background(RoundedRectangle(cornerRadius: 5).fill(Color.white)).foregroundColor(Color.blue)
				}
			}
		}
		.foregroundColor(.white)
		.preference(key: LocalNavigationBarTitleKey.self, value: "Welcome")
	}
}

struct GuideView: View {
	var body: some View {
		ZStack {
			Color.orange
			VStack {
				Text("Just go back and log in already, this is just sample code :-)")
			}
		}.foregroundColor(.white)
			.preference(key: LocalNavigationBarTitleKey.self, value: "Guide")
		
	}
}

struct LoginView: View {
	
	class LoginSession: ObservableObject {
		@Published var username: String = "John"
		@Published var password: String = "Password"
		private let _loginPublisher: PassthroughSubject<Result<LoginToken, LoginSessionError>, Never>
		let loginPublisher: AnyPublisher<Result<LoginToken, LoginSessionError>, Never>
		
		let database: UserDatabase
		
		var cancellable: AnyCancellable?
		
		enum LoginSessionError: Error {
			case usernameOrPasswordInvalid
			
			var localizedDescription: String {
				switch self {
					case .usernameOrPasswordInvalid:
						return "Username and/or password invalid."
				}
			}
		}
		
		init(_ database: UserDatabase) {
			self.database = database
			let passthrough = PassthroughSubject<Result<LoginToken, LoginSessionError>, Never>()
			self._loginPublisher = passthrough
			self.loginPublisher = passthrough.eraseToAnyPublisher()
		}
		
		func clear() {
			self.username = ""
			self.password = ""
		}
		
		func login() {
			
			let database = UserDatabase()
			
			print("Hello world")
			
			self.cancellable = self.$username
				.combineLatest(self.$password)
				.map { (username, password) in
					guard database.isUserValid(username: username, password: password) else {
						return .failure(LoginSessionError.usernameOrPasswordInvalid)
					}
					return .success(LoginToken(username: username, eMails: ["Hello from Snazzy!", "Why do you never call?"]))
			}.sink(receiveValue: { (result) in
				self._loginPublisher.send(result)
			})
			
		}
		
	}
	
	@ObservedObject var session: LoginSession
	var navigator: SnazzyNavigator<ViewState>
	
	var body: some View {
		ZStack {
			Color.blue
			VStack {
				TextField("Username", text: self.$session.username)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.foregroundColor(Color.black)
				TextField("Password", text: self.$session.password)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.foregroundColor(Color.black)
				HStack {
					Button(action: self.session.login) {
						Text("Login").padding(10).background(RoundedRectangle(cornerRadius: 5).fill(Color.white)).foregroundColor(Color.blue)
					}
					Button(action: self.session.clear) {
						Text("Clear").padding(10).background(RoundedRectangle(cornerRadius: 5).fill(Color.white)).foregroundColor(Color.blue)
					}
					
				}
			}.padding(20)
		}
		.foregroundColor(.white)
		.preference(key: LocalNavigationBarTitleKey.self, value: "Login")
		.onReceive(self.session.loginPublisher) { (result) in
			withAnimation {
				switch result {
					case .failure(let error):
						self.navigator.transition(.error(error.localizedDescription), edge: .trailing)
					case .success(let token):
						self.navigator.transition(.mailbox(token), edge: .trailing, clearHistory: true)
					
				}
			}
		}
		
	}
}

struct ErrorView: View {
	
	var errorDescription: String
	
	var body: some View {
		ZStack {
			Color.red
			VStack {
				Text(errorDescription)
			}
			
		}
		.foregroundColor(.white)
		.preference(key: LocalNavigationBarTitleKey.self, value: "Error!")
	}
}

struct MailBoxView: View {
	
	var token: LoginToken
	
	var body: some View {
		ZStack {
			Color.green
			VStack(alignment: .leading) {
				Text("Hi, \(token.username)")
				Text("Your e-mails...")
				ForEach(0..<token.eMails.count) { (index) in
					return Text(self.token.eMails[index])
				}
			}
		}
		.foregroundColor(.white)
		.preference(key: LocalNavigationBarTitleKey.self, value: "Mailbox")
		.preference(key: CanLogOutKey.self, value: true)
	}
}

