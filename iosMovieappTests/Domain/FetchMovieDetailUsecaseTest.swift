import XCTest
import Combine
@testable import iosMovieapp

class FetchMovieDetailUsecaseTest: XCTestCase {
    private var mockMovieRepository: MockMovieRepository!
    private var sut: FetchMovieDetailUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockMovieRepository = MockMovieRepository()
        sut = FetchMovieDetailUsecaseImpl(movieRepository: mockMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieRepository = nil
    }
    
    func test_execute_shouldReturnCompleted() throws {
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        
        mockMovieRepository.whenFetchMovieDetail = 
            Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: Int.random(in: 1...100))
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
        
        mockMovieRepository.whenFetchMovieDetail = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: Int.random(in: 1...100))
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
