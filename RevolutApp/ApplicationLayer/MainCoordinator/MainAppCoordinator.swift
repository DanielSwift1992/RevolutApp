import DITranquillity
import Foundation
import UIKit

open class MainAppCoordinator {
    public static var shared = MainAppCoordinator()
    open var container: DIContainer
    private let router: AppRouter

    private init() {
        container = AppFramework.configureContainer()
        router = AppRouter()
    }

    func start() {
        openMainModule()
    }

    // MARK: - Modules routing

    private func openMainModule() {
        router.openDefaultScene()
    }
}
