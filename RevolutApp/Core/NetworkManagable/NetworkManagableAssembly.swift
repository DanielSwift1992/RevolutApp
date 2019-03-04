import Foundation
import DITranquillity

final class NetworkManagablePart: DIPart {
    static func load(container: DIContainer) {
        container.register(NetworkManager.init)
            .as(NetworkManagable.self)
            .lifetime(.single)
    }
}
