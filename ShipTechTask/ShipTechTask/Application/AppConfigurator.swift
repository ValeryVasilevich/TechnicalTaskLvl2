import UIKit

enum AppConfigurator {
    static func configureAppCoordinator(_ window: UIWindow) -> AppCoordinator {
        let container = DependencyFactory(window: window)

        let authenticationProvider = container.makeAuthenticationProvider()
        let dataProvider = container.makeDataProvider()

        let appCoordinator = container.makeAppCoordinator(
            authenticationProvider: authenticationProvider,
            dataProvider: dataProvider
        )

        return appCoordinator
    }
}
