import UIKit

public class AppRouter {
    private var window: UIWindow? {
        get {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            return appDelegate?.window
        }
    }

    public func openDefaultScene() {
        let module = CurrencyAssembly.createModule()
        window?.rootViewController = module
        window?.makeKeyAndVisible()
    }
}
