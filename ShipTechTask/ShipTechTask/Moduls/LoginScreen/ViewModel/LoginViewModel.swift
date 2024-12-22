import Combine

final class LoginViewModel {

    // MARK: - Properties

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false

    @Published private(set) var isLoginButtonEnabled: Bool = false

    private let authenticationProvider: AuthenticationProvider
    var didLoginSucceeded: (() -> Void)?

    // MARK: - Initialization

    init(authenticationProvider: AuthenticationProvider) {
        self.authenticationProvider = authenticationProvider
        bindInputs()
    }

    // MARK: - Methods

    private func bindInputs() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return email.isValidEmail() && !password.isEmpty
            }
            .assign(to: &$isLoginButtonEnabled)
    }

    func login() -> AnyPublisher<Bool, Never> {
        isLoading = true
        return authenticationProvider.login(email: email, password: password)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .eraseToAnyPublisher()
    }
}
