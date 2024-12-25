import Foundation

class NetworkClient: NetworkClientProtocol {
    let session: URLSession
    
    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }
}
