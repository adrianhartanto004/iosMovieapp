import XCTest
import Combine
@testable import iosMovieapp

class FavouriteMoviesDaoTest: XCTestCase {
    private var persistentStore: MockPersistenceStore!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: FavouriteMoviesDao!
    
    override func setUp() {
        persistentStore = MockPersistenceStore()
        sut = FavouriteMoviesDaoImpl(persistentStore: persistentStore)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_insertOneItemAndFetch_shouldReturnData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: expectedMovieId)
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(
                movieId: expectedMovieId, 
                posterPath: expectedMovieDetail.posterPath!, 
                releaseDate: expectedMovieDetail.releaseDate!, 
                title: expectedMovieDetail.title!, 
                voteAverage: expectedMovieDetail.voteAverage!,
                voteCount: expectedMovieDetail.voteCount!
            )
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        sut
            .insert(movieDetail: expectedMovieDetail)
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetchAllFavouriteMovies()
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
    
    func test_insertThreeItemsAndFetch_shouldReturnData() {
        let expectedMovieId1 = Int.random(in: 1...100)
        let expectedMovieId2 = Int.random(in: 1...100)
        let expectedMovieId3 = Int.random(in: 1...100)
        let expectedMovieDetail1 = createMovieDetail(movieId: expectedMovieId1)
        let expectedMovieDetail2 = createMovieDetail(movieId: expectedMovieId2)
        let expectedMovieDetail3 = createMovieDetail(movieId: expectedMovieId3)
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(
                movieId: expectedMovieId1, 
                posterPath: expectedMovieDetail1.posterPath!, 
                releaseDate: expectedMovieDetail1.releaseDate!, 
                title: expectedMovieDetail1.title!, 
                voteAverage: expectedMovieDetail1.voteAverage!,
                voteCount: expectedMovieDetail1.voteCount!
            ),
            createNowPlayingMovies(
                movieId: expectedMovieId2, 
                posterPath: expectedMovieDetail2.posterPath!, 
                releaseDate: expectedMovieDetail2.releaseDate!, 
                title: expectedMovieDetail2.title!, 
                voteAverage: expectedMovieDetail2.voteAverage!,
                voteCount: expectedMovieDetail2.voteCount!
            ),
            createNowPlayingMovies(
                movieId: expectedMovieId3, 
                posterPath: expectedMovieDetail3.posterPath!, 
                releaseDate: expectedMovieDetail3.releaseDate!, 
                title: expectedMovieDetail3.title!, 
                voteAverage: expectedMovieDetail3.voteAverage!,
                voteCount: expectedMovieDetail3.voteCount!
            )
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        sut
            .insert(movieDetail: expectedMovieDetail1)
            .flatMap { _ -> AnyPublisher<Void, Error> in
                return self.sut.insert(movieDetail: expectedMovieDetail2)
            }
            .flatMap { _ -> AnyPublisher<Void, Error> in
                return self.sut.insert(movieDetail: expectedMovieDetail3)
            }
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetchAllFavouriteMovies()
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
        
        XCTAssertEqual(expectedNowPlayingMovies[0], actualResult[2])
        XCTAssertEqual(expectedNowPlayingMovies[1], actualResult[1])
        XCTAssertEqual(expectedNowPlayingMovies[2], actualResult[0])
    }
    
    func test_insertOneItemAndDelete_shouldReturnEmptyData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: expectedMovieId)
        let exp = XCTestExpectation(description: #function)
        
        sut
            .insert(movieDetail: expectedMovieDetail)
            .flatMap { nowPlayingMovies -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetchAllFavouriteMovies()
            }
            .flatMap { nowPlayingMovies -> AnyPublisher<Void, Error> in
                XCTAssertFalse(nowPlayingMovies.isEmpty)
                return self.sut.deleteFavouriteMovie(movieId: expectedMovieId)
            }
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetchAllFavouriteMovies()
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
    
    func test_insertThreeItemsAndDeleteOneItem_shouldReturnTwoItems() {
        let expectedMovieId1 = 1
        let expectedMovieId2 = 2
        let expectedMovieId3 = 3
        let expectedMovieDetail1 = createMovieDetail(movieId: expectedMovieId1)
        let expectedMovieDetail2 = createMovieDetail(movieId: expectedMovieId2)
        let expectedMovieDetail3 = createMovieDetail(movieId: expectedMovieId3)
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(
                movieId: expectedMovieId1, 
                posterPath: expectedMovieDetail1.posterPath!, 
                releaseDate: expectedMovieDetail1.releaseDate!, 
                title: expectedMovieDetail1.title!, 
                voteAverage: expectedMovieDetail1.voteAverage!,
                voteCount: expectedMovieDetail1.voteCount!
            ),
            createNowPlayingMovies(
                movieId: expectedMovieId2, 
                posterPath: expectedMovieDetail2.posterPath!, 
                releaseDate: expectedMovieDetail2.releaseDate!, 
                title: expectedMovieDetail2.title!, 
                voteAverage: expectedMovieDetail2.voteAverage!,
                voteCount: expectedMovieDetail2.voteCount!
            ),
            createNowPlayingMovies(
                movieId: expectedMovieId3, 
                posterPath: expectedMovieDetail3.posterPath!, 
                releaseDate: expectedMovieDetail3.releaseDate!, 
                title: expectedMovieDetail3.title!, 
                voteAverage: expectedMovieDetail3.voteAverage!,
                voteCount: expectedMovieDetail3.voteCount!
            )
        ]        
        
        let exp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        sut
            .insert(movieDetail: expectedMovieDetail1)
            .flatMap { _ -> AnyPublisher<Void, Error> in
                return self.sut.insert(movieDetail: expectedMovieDetail2)
            }
            .flatMap { _ -> AnyPublisher<Void, Error> in
                return self.sut.insert(movieDetail: expectedMovieDetail3)
            }
            .flatMap { _ -> AnyPublisher<Void, Error> in
                return self.sut.deleteFavouriteMovie(movieId: expectedMovieId3)
            }
            .flatMap { _ -> AnyPublisher<[NowPlayingMovies], Error> in
                return self.sut.fetchAllFavouriteMovies()
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
        
        XCTAssertEqual(2, actualResult.count)
        XCTAssertEqual(expectedNowPlayingMovies[0], actualResult[1])
        XCTAssertEqual(expectedNowPlayingMovies[1], actualResult[0])
    }
    
    func test_insertItemAndCheckFavouriteMovieExist_shouldReturnTrueIfMovieIdIsSame() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: expectedMovieId)
        
        let exp = XCTestExpectation(description: #function)
        var actualResult: Bool!
        
        sut
            .insert(movieDetail: expectedMovieDetail)
            .flatMap { _ -> AnyPublisher<Bool, Error> in
                return self.sut.doesFavouriteMovieExist(movieId: expectedMovieId)
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
        
        XCTAssertTrue(actualResult)
    }
    
    func test_insertItemAndCheckFavouriteMovieExist_shouldReturnTrueIfMovieIdIsNotSame() {
        let expectedMovieId = 1
        let expectedMovieDetail = createMovieDetail(movieId: expectedMovieId)
        
        let exp = XCTestExpectation(description: #function)
        var actualResult: Bool!
        
        sut
            .insert(movieDetail: expectedMovieDetail)
            .flatMap { _ -> AnyPublisher<Bool, Error> in
                return self.sut.doesFavouriteMovieExist(movieId: 2)
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
        
        XCTAssertFalse(actualResult)
    }
}
