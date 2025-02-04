import Foundation
import Combine

@testable import iosMovieapp

class MockNetworkClient: NetworkClientProtocol, TestHelper {
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [RequestMocking.self, RequestBlocking.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        return URLSession(configuration: configuration)
    }
    
    func mock<T: Codable>(
        request: RequestBuilder,
        fileName: String,
        type: T.Type
    ) throws {
        let decodedJSONFile = decodeJSONFile(filename: fileName, type: type.self)
        let encodedObject = encodeObject(object: decodedJSONFile)
        let mock = try RequestMocking.MockedResponse(
            request: request,
            result: .success(encodedObject)
        )
        RequestMocking.add(mock: mock)
    }
    
    func mockError(
        request: RequestBuilder,
        error: Error,
        httpCode: Int
    ) throws {
        let mock = try RequestMocking.MockedResponse(
            request: request,
            result: .failure(error),
            httpCode: httpCode
        )
        RequestMocking.add(mock: mock)
    }
}
