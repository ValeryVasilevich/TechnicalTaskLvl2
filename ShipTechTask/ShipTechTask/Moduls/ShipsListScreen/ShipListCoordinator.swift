import UIKit

final class ShipListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let dataProvider: DataProvider

    var finish: ((String) -> Void)?

    init(navigationController: UINavigationController, dataProvider: DataProvider) {
        self.navigationController = navigationController
        self.dataProvider = dataProvider
    }

    func start() {
        let shipsListViewModel = ShipsListViewModel(dataProvider: dataProvider)
        let shipsListViewController = ShipListViewController(viewModel: shipsListViewModel)

        shipsListViewModel.didSelectShip = { [weak self] id in
            self?.finish?(id)
        }

        navigationController.pushViewController(shipsListViewController, animated: true)
    }
}
