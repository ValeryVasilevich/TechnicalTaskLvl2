import Foundation
import Combine

fileprivate enum AuthConstants {
    static let email = "test@gmail.com"
    static let password = "password"
    static let loginDelay: TimeInterval = 2.0
}

protocol AuthenticationProvider {
    var isUserLoggedIn: Bool { get }
    func login(email: String, password: String) -> AnyPublisher<Bool, Never>
    func logout()
}

final class DefaultAuthenticationProvider: AuthenticationProvider {
    private(set) var isUserLoggedInPublisher = CurrentValueSubject<Bool, Never>(false)
    var isUserLoggedIn: Bool { isUserLoggedInPublisher.value }

    func login(email: String, password: String) -> AnyPublisher<Bool, Never> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + AuthConstants.loginDelay) {
                let success = email == AuthConstants.email && password == AuthConstants.password
                if success { self.isUserLoggedInPublisher.send(true) }
                promise(.success(success))
            }
        }
        .eraseToAnyPublisher()
    }

    func logout() {
        isUserLoggedInPublisher.send(false)
    }
}
