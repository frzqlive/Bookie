import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let container = DependencyContainer()
        self.coordinator = AppCoordinator(window: window, container: container)
        self.coordinator?.start()
    }
}
