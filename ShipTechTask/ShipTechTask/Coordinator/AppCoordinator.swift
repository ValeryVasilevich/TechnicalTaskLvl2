import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let window: UIWindow

    private let authenticationProvider: AuthenticationProvider
    private let dataProvider: DataProvider

    init(window: UIWindow, authenticationProvider: AuthenticationProvider, dataProvider: DataProvider) {
        self.window = window
        self.navigationController = UINavigationController()
        self.authenticationProvider = authenticationProvider
        self.dataProvider = dataProvider
    }

    func start() {
        showLogin()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showLogin() {
        let loginViewModel = LoginViewModel(authenticationProvider: authenticationProvider)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewModel.didLoginSucceeded = { [weak self] in
            self?.showShipsList()
        }
        navigationController.setViewControllers([loginViewController], animated: false)
    }

    private func showShipsList() {
        let shipsListViewModel = ShipsListViewModel(dataProvider: dataProvider)
        let shipsListViewController = ShipListViewController(viewModel: shipsListViewModel)
//        shipsListViewModel.didSelectShip = { [weak self] ship in
//            self?.showShipDetails(for: ship)
//        }
        navigationController.pushViewController(shipsListViewController, animated: true)
    }

    private func showShipDetails(for ship: Ship) {
        let shipDetailsViewModel = ShipDetailsViewModel(dataProvider: dataProvider)
        let shipDetailsViewController = ShipDetailsViewController(viewModel: shipDetailsViewModel)
        navigationController.present(shipDetailsViewController, animated: true, completion: nil)
    }
}
