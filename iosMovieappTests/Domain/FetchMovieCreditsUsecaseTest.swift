import XCTest
import Combine
@testable import iosMovieapp

class FetchMovieCreditsUsecaseTest: XCTestCase {
    private var mockMovieRepository: MockMovieRepository!
    private var sut: FetchMovieCreditsUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockMovieRepository = MockMovieRepository()
        sut = FetchMovieCreditsUsecaseImpl(movieRepository: mockMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieRepository = nil
    }
    
    func test_execute_shouldReturnCompleted() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        
        mockMovieRepository.whenFetchMovieCredits = 
            Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: movieId)
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
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        let error = APIError.noNetwork
        
        mockMovieRepository.whenFetchMovieCredits = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: movieId)
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
