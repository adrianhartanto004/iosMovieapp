import Foundation
import Combine

typealias BaseAPIProtocol = NetworkClientProtocol

typealias AnyPublisherResult<M> = AnyPublisher<M, Error>

protocol NetworkClientProtocol {
    var session: URLSession { get }
}

extension NetworkClientProtocol {
    @discardableResult
    func perform<M, T>(
        with request: RequestBuilder,
        decoder: JSONDecoder,
        scheduler: T,
        responseObject type: M.Type
    ) -> AnyPublisher<M, Error> where M: Decodable, T: Scheduler {
        let urlRequest = request.buildURLRequest()
        return publisher(request: urlRequest)
            .receive(on: scheduler)
            .map(\.data)
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                return error as? APIError ?? .general
            }
            .eraseToAnyPublisher()
    }
    
    private func publisher(request: URLRequest) ->
    AnyPublisher<(data: Data,response: URLResponse), Error> {
        return self.session.dataTaskPublisher(for: request)
            .mapError { APIError.httpCode($0.errorCode) }
            .tryMap {
                assert(!Thread.isMainThread)
                guard let httpResponse = $0.response as? HTTPURLResponse else {
                    throw APIError.unexpectedResponse
                }
                if !httpResponse.isResponseOK {
                    throw APIError.httpCode(httpResponse.statusCode)
                }
                
                return $0
            }
            .eraseToAnyPublisher()
    }
}
