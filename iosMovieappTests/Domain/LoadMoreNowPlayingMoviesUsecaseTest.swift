import XCTest
import Combine
@testable import iosMovieapp

class LoadMoreNowPlayingMoviesUsecaseTest: XCTestCase {
    private var mockMovieRepository: MockMovieRepository!
    private var sut: LoadMoreNowPlayingMoviesUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockMovieRepository = MockMovieRepository()
        sut = LoadMoreNowPlayingMoviesUsecaseImpl(movieRepository: mockMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieRepository = nil
    }
    
    func test_execute_shouldReturnCompleted() throws {
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        
        mockMovieRepository.whenLoadMoreNowPlayingMovies = 
            Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .execute(page: 1)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isExecuteCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isExecuteCompleted)
    }
    
    func test_execute_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        let error = APIError.noNetwork
        
        mockMovieRepository.whenLoadMoreNowPlayingMovies = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .execute(page: 1)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let failure):
                        XCTAssertEqual(error.localizedDescription, failure.localizedDescription)
                    }
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isExecuteCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(isExecuteCompleted)
    }
}
