import UIKit

struct DependencyFactory {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Dependency Factories

    func makeAuthenticationProvider() -> AuthenticationProvider {
        DefaultAuthenticationProvider()
    }

    func makeNetworkService() -> ShipsNetworkService {
        ShipsNetworkService()
    }

    func makeDataStore() -> LocalStorageManager {
        ShipsStorageManager.shared
    }

    func makeConnectionChecker() -> ConnectionChecker {
        NetworkChecker()
    }

    func makeDataProvider() -> DataProvider {
        DataProvider(
            networkService: makeNetworkService(),
            dataStore: makeDataStore(),
            connectionChecker: makeConnectionChecker()
        )
    }

    func makeAppCoordinator(
        authenticationProvider: AuthenticationProvider,
        dataProvider: DataProvider
    ) -> AppCoordinator {
        AppCoordinator(
            window: window,
            authenticationProvider: authenticationProvider,
            dataProvider: dataProvider
        )
    }
}
