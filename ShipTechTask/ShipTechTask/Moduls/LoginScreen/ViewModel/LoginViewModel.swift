import Combine

final class LoginViewModel {

    // MARK: - Properties

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false

    @Published private(set) var isLoginButtonEnabled: Bool = false

    private let authenticationProvider: AuthenticationProvider

    // MARK: - Initialization

    init(authenticationProvider: AuthenticationProvider) {
        self.authenticationProvider = authenticationProvider
        bindInputs()
    }

    // MARK: - Methods

    private func bindInputs() {
        Publishers.CombineLatest($email, $password)
            .map { [weak self] email, password in
                guard let self else { return false }
                return email.isValidEmail() && !password.isEmpty
            }
            .assign(to: &$isLoginButtonEnabled)
    }

    func login() -> AnyPublisher<Bool, Never> {
        isLoading = true
        return authenticationProvider.login(email: email, password: password)
            .handleEvents(receiveRequest:  { [weak self] _ in
                self?.isLoading = false
            })
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}
