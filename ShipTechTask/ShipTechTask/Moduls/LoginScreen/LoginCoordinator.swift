import UIKit

final class LoginCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let authenticationProvider: AuthenticationProvider

    var finish: (() -> Void)?

    init(navigationController: UINavigationController, authenticationProvider: AuthenticationProvider) {
        self.navigationController = navigationController
        self.authenticationProvider = authenticationProvider
    }

    func start() {
        let loginViewModel = LoginViewModel(authenticationProvider: authenticationProvider)
        let loginViewController = LoginViewController(viewModel: loginViewModel)

        loginViewModel.didLoginSucceeded = { [weak self] in
            self?.finish?()
        }

        navigationController.pushViewController(loginViewController, animated: false)
    }
}
