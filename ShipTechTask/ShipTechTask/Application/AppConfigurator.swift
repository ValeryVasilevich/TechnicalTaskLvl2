import UIKit

enum AppConfigurator {
    static func buildAppCoordinator(_ window: UIWindow) -> AppCoordinator {
        let factory = ServicesFactory(window: window)

        let authenticationProvider = factory.makeAuthenticationProvider()
        let dataProvider = factory.makeDataProvider()

        let appCoordinator = factory.makeAppCoordinator(
            authenticationProvider: authenticationProvider,
            dataProvider: dataProvider
        )

        return appCoordinator
    }
}
