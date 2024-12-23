import UIKit

final class ShipDetailsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let dataProvider: ShipDataProvider
    private let shipId: String

    init(navigationController: UINavigationController, dataProvider: ShipDataProvider, shipId: String) {
        self.navigationController = navigationController
        self.dataProvider = dataProvider
        self.shipId = shipId
    }

    func start() {
        let shipDetailsViewModel = ShipDetailsViewModel(dataProvider: dataProvider, shipId: shipId)
        let shipDetailsViewController = ShipDetailsViewController(viewModel: shipDetailsViewModel)


        navigationController.present(shipDetailsViewController, animated: true, completion: nil)
    }
}
