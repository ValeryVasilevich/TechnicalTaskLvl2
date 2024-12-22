import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        showLogin()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showLogin() {
        let authenticationProvider = DefaultAuthenticationProvider()
        let loginViewModel = LoginViewModel(authenticationProvider: authenticationProvider)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewModel.didLogin = { [weak self] in
            self?.showShipsList()
        }
        navigationController.setViewControllers([loginViewController], animated: false)
    }

    private func showShipsList() {
        let networkService = ShipsNetworkService()
        let dataStore = ShipsStorageManager.shared
        let connectionChecker = NetworkChecker()
        let dataProvider = DataProvider(
            networkService: networkService,
            dataStore: dataStore,
            connectionChecker: connectionChecker
        )
        let shipsListViewModel = ShipsListViewModel(dataProvider: dataProvider)
        let shipsListViewController = ShipListViewController(viewModel: shipsListViewModel)
        navigationController.pushViewController(shipsListViewController, animated: true)
    }
}
