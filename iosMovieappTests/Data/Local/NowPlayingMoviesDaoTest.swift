import XCTest
import Combine
@testable import iosMovieapp

class NowPlayingMoviesDaoTest: XCTestCase {
    private var persistentStore: MockPersistenceStore!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: NowPlayingMoviesDao!
    
    override func setUp() {
        persistentStore = MockPersistenceStore()
        sut = NowPlayingMoviesDaoImpl(persistentStore: persistentStore)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_insertAndFetch_shouldReturnData() {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1),
            createNowPlayingMovies(movieId: 2),
            createNowPlayingMovies(movieId: 3)
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        sut
            .insertAll(expectedNowPlayingMovies)
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetch(limit: nil)
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
        
        XCTAssertEqual(expectedNowPlayingMovies, actualResult)
    }
    
    func test_insertAndFetchLimitFifteen_shouldReturnFifteenData() {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1),
            createNowPlayingMovies(movieId: 2),
            createNowPlayingMovies(movieId: 3),
            createNowPlayingMovies(movieId: 4),
            createNowPlayingMovies(movieId: 5),
            createNowPlayingMovies(movieId: 6),
            createNowPlayingMovies(movieId: 7),
            createNowPlayingMovies(movieId: 8),
            createNowPlayingMovies(movieId: 9),
            createNowPlayingMovies(movieId: 10),
            createNowPlayingMovies(movieId: 11),
            createNowPlayingMovies(movieId: 12),
            createNowPlayingMovies(movieId: 13),
            createNowPlayingMovies(movieId: 14),
            createNowPlayingMovies(movieId: 15),
        ]
        
        let exp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        sut
            .insertAll(expectedNowPlayingMovies)
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetch(limit: 15)
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
        
        XCTAssertEqual(expectedNowPlayingMovies, actualResult)
    }
    
    func test_insertAndDeleteAll_shouldReturnEmpty() {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1),
            createNowPlayingMovies(movieId: 2),
            createNowPlayingMovies(movieId: 3)
        ]
        let exp = XCTestExpectation(description: #function)
        
        sut
            .insertAll(expectedNowPlayingMovies)
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetch(limit: nil)
            }
            .flatMap { nowPlayingMovies -> AnyPublisher<Void, Error> in
                XCTAssertFalse(nowPlayingMovies.isEmpty)
                return self.sut.deleteAll()
            }
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetch(limit: nil)
            }
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { value in
                    XCTAssertTrue(value.isEmpty)
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
}
