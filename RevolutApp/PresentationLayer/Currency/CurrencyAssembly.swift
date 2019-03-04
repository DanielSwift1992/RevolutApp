import UIKit
import DITranquillity

final class CurrencyPart: DIPart {
    static func load(container: DIContainer) {
        container.register1(CurrencyRouter.init)
            .as(CurrencyRouterProtocol.self)
            .lifetime(.objectGraph)
        
        container.register(CurrencyPresenter.init)
            .as(CurrencyEventHandler.self)
            .lifetime(.objectGraph)
        
        container.register {
            CurrencyViewController()
            }
            .as(CurrencyViewBehavior.self)
            .injection(cycle: true, { $0.handler = $1 })
            .lifetime(.objectGraph)
    }
}

final class CurrencyAssembly {
    class func createModule() -> CurrencyViewController {
        let module: CurrencyViewController = MainAppCoordinator.shared.container.resolve()
        return module
    }
}

// MARK: - Route

protocol CurrencyRoute {
    func open()
}

extension CurrencyRoute {
    func open(parent: UIViewController, animated flag: Bool = true) {
        let module = CurrencyAssembly.createModule()
        parent.navigationController?.pushViewController(module, animated: flag)
    }
}
