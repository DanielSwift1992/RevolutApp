import Foundation
import DITranquillity

protocol RateServiceProtocol: class {
    typealias T = [Rate]
    func getRates(onSuccess: @escaping (Self.T) -> Void, onError: @escaping (Error) -> Void)
    func getRates(base: String, onSuccess: @escaping (Self.T) -> Void, onError: @escaping (Error) -> Void)
}

final class RateService: RateServiceProtocol {
    let requestManager: NetworkManagable = MainAppCoordinator.shared.container.resolve()
    private let urlRequest: URLRequest = .init(url: APIRequestURL.Currency.url,
                                               resultDecoder: RateDecoder.self)
    
    func getRates(onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
        urlRequest.parameters = nil
        requestManager.request(request: urlRequest,
                               onSuccess: onSuccess,
                               onError: onError)
    }
    
    func getRates(base: String, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
        guard base.isEmpty == false else {
            getRates(onSuccess: onSuccess, onError: onError)
            return
        }
        
        urlRequest.parameters = [APIRequestURL.Currency.base: base]
        requestManager.request(request: urlRequest,
                               onSuccess: onSuccess,
                               onError: onError)
    }
}

// Mark: - Assembly

final class RateDataRequestingPart: DIPart {
    static func load(container: DIContainer) {
        container.register(RateService.init)
            .as(RateServiceProtocol.self)
            .lifetime(.objectGraph)
    }
}
