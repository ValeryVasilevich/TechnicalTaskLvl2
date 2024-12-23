import Foundation
import Combine

fileprivate enum AuthConstants {
    static let email = "test@gmail.com"
    static let password = "password"
    static let loginDelay: TimeInterval = 2.0
    static let userTokenKey = "userAuthToken"
}

protocol AuthenticationProvider {
    var isUserLoggedIn: Bool { get }
    func login(email: String, password: String) -> AnyPublisher<Bool, Never>
    func logout()
}

final class DefaultAuthenticationProvider: AuthenticationProvider {
    private let userDefaults = UserDefaults.standard
    private(set) var isUserLoggedInPublisher = CurrentValueSubject<Bool, Never>(false)

    var isUserLoggedIn: Bool {
        userDefaults.string(forKey: AuthConstants.userTokenKey) != nil
    }

    init() {
        isUserLoggedInPublisher.send(isUserLoggedIn)
    }

    func login(email: String, password: String) -> AnyPublisher<Bool, Never> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + AuthConstants.loginDelay) {
                let success = email == AuthConstants.email && password == AuthConstants.password
                if success {
                    self.userDefaults.set(UUID().uuidString, forKey: AuthConstants.userTokenKey)
                    self.isUserLoggedInPublisher.send(true)
                }
                promise(.success(success))
            }
        }
        .eraseToAnyPublisher()
    }

    func logout() {
        userDefaults.removeObject(forKey: AuthConstants.userTokenKey)
        isUserLoggedInPublisher.send(false)
    }
}
