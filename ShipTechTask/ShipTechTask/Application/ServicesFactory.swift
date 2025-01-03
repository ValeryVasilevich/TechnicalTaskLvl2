import UIKit

struct ServicesFactory {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Dependency Factories

    func makeAuthenticationProvider() -> AuthenticationProvider {
        LocalAuthenticationProvider()
    }

    func makeNetworkService() -> ShipsNetworkService {
        let url = URL(string: AppConstants.domain)!
        return ShipsNetworkService(baseURL: url)
    }

    func makeDataStore() -> LocalStorageManager {
        ShipsStorageManager.shared
    }

    func makeConnectionChecker() -> ConnectionChecker {
        NetworkChecker()
    }

    func makeDataProvider() -> ShipDataProvider {
        ShipDataProvider(
            networkService: makeNetworkService(),
            dataStore: makeDataStore(),
            connectionChecker: makeConnectionChecker()
        )
    }

    func makeAppCoordinator(
        authenticationProvider: AuthenticationProvider,
        dataProvider: ShipDataProvider
    ) -> AppCoordinator {
        AppCoordinator(
            window: window,
            authenticationProvider: authenticationProvider,
            dataProvider: dataProvider
        )
    }
}
