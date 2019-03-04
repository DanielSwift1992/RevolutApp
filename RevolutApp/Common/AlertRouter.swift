import UIKit

protocol AlertRoute {
    func showAlert(title: String)
}

extension AlertRoute where Self: RouterProtocol {
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        controller.present(alert, animated: true, completion: nil)
    }
}
