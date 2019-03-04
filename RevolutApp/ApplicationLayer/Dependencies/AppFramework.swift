import DITranquillity
import Foundation

public class AppFramework: DIFramework {
    public static func load(container: DIContainer) {
        container.append(part: ServicesPart.self)
        container.append(part: ControllersPart.self)
    }
    
    public static func configureContainer() -> DIContainer {
        let container = DIContainer()
        container.append(framework: self.self)
        if !container.validate() {
            fatalError()
        }
        return container
    }
}

protocol DIFrameworkPart: DIPart {
    static var parts: [DIPart.Type] { get }
}

extension DIFrameworkPart {
    static func load(container: DIContainer) {
        for part in self.parts {
            container.append(part: part)
        }
    }
}

private class ServicesPart: DIFrameworkPart {
    static let parts: [DIPart.Type] = [
        NetworkManagablePart.self,
        RateDataRequestingPart.self,
        RatesUpdatablePart.self
        ]
}

private class ControllersPart: DIFrameworkPart {
    static let parts: [DIPart.Type] = [
        CurrencyPart.self
        ]
}
