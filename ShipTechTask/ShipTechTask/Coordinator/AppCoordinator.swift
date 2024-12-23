import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
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
        let loginCoordinator = LoginCoordinator(
            navigationController: navigationController,
            authenticationProvider: authenticationProvider
        )
        loginCoordinator.finish = { [weak self] in
            self?.showShipList()
        }
        addChild(loginCoordinator)
        loginCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showShipList() {
        let shipListCoordinator = ShipListCoordinator(
            navigationController: navigationController,
            dataProvider: dataProvider
        )
        shipListCoordinator.finish = { [weak self] in
            self?.showShipDetails(with: $0)
        }
        addChild(shipListCoordinator)
        shipListCoordinator.start()
    }

    private func showShipDetails(with id: String) {
        let shipDetailsCoordinator = ShipDetailsCoordinator(
            navigationController: navigationController,
            dataProvider: dataProvider,
            shipId: id
        )
        addChild(shipDetailsCoordinator)
        shipDetailsCoordinator.start()
    }
}
