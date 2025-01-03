import Foundation
import Combine

fileprivate enum AuthConstants {
    static let email = "test@gmail.com"
    static let password = "password"
    static let loginDelay: TimeInterval = 2.0
    static let userTokenKey = "userAuthToken"
}

protocol AuthenticationProvider {
    var authenticationStatusPublisher: AnyPublisher<Bool, Never> { get }
    func login(email: String, password: String) -> AnyPublisher<Bool, Never>
    func logout()
}

final class LocalAuthenticationProvider: AuthenticationProvider {
    private let userDefaults = UserDefaults.standard
    private var authenticationStatusSubject = CurrentValueSubject<Bool, Never>(false)

    var authenticationStatusPublisher: AnyPublisher<Bool, Never> {
        return authenticationStatusSubject.eraseToAnyPublisher()
    }

    private var isUserLoggedIn: Bool {
        return userDefaults.string(forKey: AuthConstants.userTokenKey) != nil
    }

    private func updateAuthenticationStatus() {
        authenticationStatusSubject.send(isUserLoggedIn)
    }

    init() {
        updateAuthenticationStatus()
    }

    func login(email: String, password: String) -> AnyPublisher<Bool, Never> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + AuthConstants.loginDelay) {
                let success = email == AuthConstants.email && password == AuthConstants.password
                if success {
                    self.userDefaults.set(UUID().uuidString, forKey: AuthConstants.userTokenKey)
                    self.updateAuthenticationStatus()
                }
                promise(.success(success))
            }
        }
        .eraseToAnyPublisher()
    }

    func logout() {
        userDefaults.removeObject(forKey: AuthConstants.userTokenKey)
        updateAuthenticationStatus()
    }
}
