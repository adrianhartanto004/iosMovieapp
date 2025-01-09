import XCTest
import Combine
@testable import iosMovieapp

class GetAuthorReviewsUsecaseTest: XCTestCase {
    private var mockMovieRepository: MockMovieRepository!
    private var sut: GetAuthorReviewsUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockMovieRepository = MockMovieRepository()
        sut = GetAuthorReviewsUsecaseImpl(movieRepository: mockMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieRepository = nil
    }
    
    func test_execute_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        let expectedAuthorReviews = [createAuthorReview(), createAuthorReview(), createAuthorReview()]
        var actualResult: [AuthorReview] = []
        
        mockMovieRepository.whenGetAuthorReviews = 
            Result.success(expectedAuthorReviews).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: movieId)
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
        
        XCTAssertEqual(expectedAuthorReviews, actualResult)
    }
    
    func test_execute_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockMovieRepository.whenGetAuthorReviews =
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
