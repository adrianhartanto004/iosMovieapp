import XCTest
import Combine
@testable import iosMovieapp

class NowPlayingMoviesServiceTest: XCTestCase, TestHelper {
    private var mockNetworkClient: MockNetworkClient!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: NowPlayingMoviesService!
    
    override func setUp() {
        mockNetworkClient = MockNetworkClient()
        sut = NowPlayingMoviesServiceImpl(clientURLSession: mockNetworkClient)
    }
    
    override func tearDown() {
        sut = nil
        RequestMocking.removeAllMocks()
    }
    
    func test_fetchData_shouldReturnData() throws {
        let expectedNowPlayingMoviesList = decodeJSONFile(
            filename: "NowPlayingMoviesListResponse", type: NowPlayingMoviesList.self
        )
        let exp = XCTestExpectation(description: #function)
        var actualResult: NowPlayingMoviesList?
        
        try mockNetworkClient.mock(
            request: HttpRequest(request: NowPlayingMoviesRequest(page: 1)),
            fileName: "NowPlayingMoviesListResponse",
            type: NowPlayingMoviesList.self
        )
        
        sut
            .fetch(page: 1)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { value in
                    actualResult = value
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(expectedNowPlayingMoviesList, actualResult)
        XCTAssertEqual(expectedNowPlayingMoviesList.nowPlayingMovies, actualResult?.nowPlayingMovies)
    }
    
    func test_fetchData_networkError() throws {
        let exp = XCTestExpectation(description: #function)
        let expectedError = APIError.noNetwork
        
        try mockNetworkClient.mockError(
            request: HttpRequest(request: NowPlayingMoviesRequest(page: 1)),
            error: expectedError,
            httpCode: -1009
        )
        
        sut
            .fetch(page: 1)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertEqual(
                            expectedError.localizedDescription,
                            error.localizedDescription
                        )
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
}
