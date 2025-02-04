import Foundation
import Combine

class NetworkClientManager<Target: RequestBuilder> {
    
    typealias AnyPublisherResult<M> = AnyPublisher<M, Error>
    
    private let clientURLSession: NetworkClientProtocol
    
    public init(
        clientURLSession: NetworkClientProtocol = NetworkClient()
    ) {
        self.clientURLSession = clientURLSession
    }
    
    func request<M, T>(
        request: Target,
        decoder: JSONDecoder = .init(),
        scheduler: T,
        responseObject type: M.Type
    ) -> AnyPublisherResult<M> where M: Decodable, T: Scheduler {
        return clientURLSession.perform(
            with: request,
            decoder: decoder,
            scheduler: scheduler,
            responseObject: type
        )
    }
}
