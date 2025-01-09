import XCTest
import Combine
@testable import iosMovieapp

class MovieAuthorReviewsDaoTest: XCTestCase {
    private var persistentStore: MockPersistenceStore!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: MovieAuthorReviewsDao!
    
    override func setUp() {
        persistentStore = MockPersistenceStore()
        sut = MovieAuthorReviewsDaoImpl(persistentStore: persistentStore)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_insertAndFetch_shouldReturnData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedAuthorReviews = [
            createAuthorReview(),
            createAuthorReview(),
            createAuthorReview()
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [AuthorReview] = []
        
        sut
            .insertAll(movieId: expectedMovieId, expectedAuthorReviews)
            .flatMap { _ -> AnyPublisher<[AuthorReview], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
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
    
    func test_insertEmptyAndFetch_shouldReturnEmptyData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedAuthorReviews: [AuthorReview] = []
        let exp = XCTestExpectation(description: #function)
        var actualResult: [AuthorReview] = []
        
        sut
            .insertAll(movieId: expectedMovieId, expectedAuthorReviews)
            .flatMap { _ -> AnyPublisher<[AuthorReview], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
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
    
    func test_insertAndDeleteAll_shouldReturnNotAvailableError() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedAuthorReviews = [
            createAuthorReview(),
            createAuthorReview(),
            createAuthorReview()
        ]
        let exp = XCTestExpectation(description: #function)
        
        sut
            .insertAll(movieId: expectedMovieId, expectedAuthorReviews)
            .flatMap { _ -> AnyPublisher<[AuthorReview], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
            .flatMap { authorReviews -> AnyPublisher<Void, Error> in
                XCTAssertFalse(authorReviews.isEmpty)
                return self.sut.deleteMovieAuthorReviews(movieId: expectedMovieId)
            }
            .flatMap { _ -> AnyPublisher<[AuthorReview], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssertEqual(error as? CoreDataError, .dataNotAvailable)
                        exp.fulfill()
                    case .finished:
                        XCTFail("Expected failure, but completed successfully.")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Expected no value, but got one.")
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
}
