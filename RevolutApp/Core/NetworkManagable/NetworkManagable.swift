import Foundation
import Alamofire

enum RequestDataError: Error {
    case unknowed, decodingError
}

protocol NetworkManagable {
    func request<T>(request: URLRequest<T>, onSuccess: @escaping (T.U) -> Void, onError: @escaping (Error) -> Void)
}

final class NetworkManager: NetworkManagable, Weakifiable {
    private var manager = Alamofire.SessionManager(configuration: .default)
    
    func request<T>(request: URLRequest<T>, onSuccess: @escaping (T.U) -> Void, onError: @escaping (Error) -> Void) {
        manager.request(request.url,
                        method: request.method,
                        parameters: request.parameters,
                        encoding: request.encoding,
                        headers: request.headers)

            .responseData(completionHandler: weak(self|.responseHandler,
                                                  request.resultDecoder,
                                                  onSuccess,
                                                  onError))
    }
    
    private func responseHandler<T: DataDecodable>(_ response: DataResponse<Data>,
                                                      _ resultDecoder: T.Type,
                                                      _ onSuccess: @escaping (T.U) -> Void,
                                                      _ onError: @escaping (Error) -> Void) {
        if let error = response.error {
            onError(error)
            return
        }
        
        guard let data = response.data else {
            onError(RequestDataError.unknowed)
            return
        }
        
        guard let object = try? resultDecoder.decode(data) else {
            onError(RequestDataError.decodingError)
            return
        }
        
        onSuccess(object)
    }
}

final class URLRequest<T: DataDecodable> {
    var url: URLConvertible
    var method: HTTPMethod = .get
    var parameters: Parameters?
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: HTTPHeaders?
    var resultDecoder: T.Type
    
    init(url: URLConvertible, resultDecoder: T.Type) {
        self.url = url
        self.resultDecoder = resultDecoder
    }
}

protocol DataDecodable {
    associatedtype U
    static func decode(_ data: Data) throws -> U
}
