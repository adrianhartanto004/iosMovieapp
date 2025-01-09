import XCTest
import Combine
@testable import iosMovieapp

class MovieCastsDaoTest: XCTestCase {
    private var persistentStore: MockPersistenceStore!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: MovieCastsDao!
    
    override func setUp() {
        persistentStore = MockPersistenceStore()
        sut = MovieCastsDaoImpl(persistentStore: persistentStore)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_insertAndFetch_shouldReturnData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedCasts = [
            createCast(),
            createCast(),
            createCast()
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [Cast] = []
        
        sut
            .insertAll(movieId: expectedMovieId, expectedCasts)
            .flatMap { _ -> AnyPublisher<[Cast], Error> in
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
        
        XCTAssertEqual(expectedCasts, actualResult)
    }
    
    func test_insertEmptyAndFetch_shouldReturnEmptyData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedCasts: [Cast] = []
        let exp = XCTestExpectation(description: #function)
        var actualResult: [Cast] = []
        
        sut
            .insertAll(movieId: expectedMovieId, expectedCasts)
            .flatMap { _ -> AnyPublisher<[Cast], Error> in
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
        
        XCTAssertEqual(expectedCasts, actualResult)
    }
    
    func test_insertAndDeleteAll_shouldReturnNotAvailableError() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedCasts = [
            createCast(),
            createCast(),
            createCast()
        ]
        let exp = XCTestExpectation(description: #function)
        
        sut
            .insertAll(movieId: expectedMovieId, expectedCasts)
            .flatMap { _ -> AnyPublisher<[Cast], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
            .flatMap { casts -> AnyPublisher<Void, Error> in
                XCTAssertFalse(casts.isEmpty)
                return self.sut.deleteMovieCredit(movieId: expectedMovieId)
            }
            .flatMap { _ -> AnyPublisher<[Cast], Error> in
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
