import UIKit

extension NSObjectProtocol {
    @discardableResult
    func apply(_ closure: (Self) -> () ) -> Self {
    { closure(self) }()
        return self
    }
}
