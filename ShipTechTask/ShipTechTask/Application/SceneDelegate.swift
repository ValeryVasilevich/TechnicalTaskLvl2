import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let container = DependencyFactory(window: window)

        let authenticationProvider = container.makeAuthenticationProvider()
        let dataProvider = container.makeDataProvider()

        let appCoordinator = container.makeAppCoordinator(
            authenticationProvider: authenticationProvider,
            dataProvider: dataProvider
        )

        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }
}
