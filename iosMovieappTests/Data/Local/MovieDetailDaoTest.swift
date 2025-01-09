import XCTest
import Combine
@testable import iosMovieapp

class MovieDetailDaoTest: XCTestCase {
    private var persistentStore: MockPersistenceStore!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: MovieDetailDao!
    
    override func setUp() {
        persistentStore = MockPersistenceStore()
        sut = MovieDetailDaoImpl(persistentStore: persistentStore)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_insertAndFetch_shouldReturnData() {
        let expectedMovieId = 845781
        let expectedMovieDetail = createMovieDetail(movieId: expectedMovieId)
        let exp = XCTestExpectation(description: #function)
        var actualResult: MovieDetail!
        
        sut
            .insert(expectedMovieDetail)
            .flatMap { _ -> AnyPublisher<MovieDetail, Error> in
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
        
        XCTAssertEqual(expectedMovieDetail, actualResult)
    }
    
    func test_insertAndDeleteAll_shouldReturnError() {
        let expectedMovieId = 845781
        let expectedMovieDetail = createMovieDetail(movieId: expectedMovieId)
        let exp = XCTestExpectation(description: #function)
        
        sut
            .insert(expectedMovieDetail)
            .flatMap { _ -> AnyPublisher<MovieDetail, Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
            .flatMap { movieDetail -> AnyPublisher<Void, Error> in
                XCTAssertNotNil(movieDetail)
                return self.sut.deleteMovieDetail(movieId: expectedMovieId)
            }
            .flatMap { _ -> AnyPublisher<MovieDetail, Error> in
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
