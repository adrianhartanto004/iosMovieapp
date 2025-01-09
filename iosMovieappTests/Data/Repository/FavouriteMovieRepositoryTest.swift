import XCTest
import Combine
@testable import iosMovieapp

class FavouriteMovieRepositoryTest: XCTestCase {
    private var mockFavouriteMoviesDao: MockFavouriteMoviesDao!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: FavouriteMovieRepository!
    
    override func setUp() {
        mockFavouriteMoviesDao = MockFavouriteMoviesDao()
        
        sut = FavouriteMovieRepositoryImpl(
            favouriteMoviesDao: mockFavouriteMoviesDao
        )
    }
    
    override func tearDown() {
        sut = nil
        mockFavouriteMoviesDao = nil
    }
    
    func test_addFavouriteMoviePreviouslyNotExist_shouldReturnInsertFavouriteMovieSuccess() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let exp = XCTestExpectation(description: #function)
        var isCompleted: Bool = false
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = 
            Result.success(false).publisher.eraseToAnyPublisher()
        mockFavouriteMoviesDao.whenInsert = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .addFavouriteMovie(movieDetail: expectedMovieDetail)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isCompleted)
    }
    
    func test_addFavouriteMoviePreviouslyExist_shouldReturnDeleteFavouriteMovieSuccess() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let exp = XCTestExpectation(description: #function)
        var isCompleted: Bool = false
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = 
            Result.success(true).publisher.eraseToAnyPublisher()
        mockFavouriteMoviesDao.whenDeleteFavouriteMovie = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .addFavouriteMovie(movieDetail: expectedMovieDetail)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isCompleted)
    }
    
    func test_addFavouriteMoviePreviouslyNotExist_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .addFavouriteMovie(movieDetail: expectedMovieDetail)
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
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(isFetchCompleted)
    }
    
    func test_addFavouriteMoviePreviouslyNotExist_insertFavouriteMovie_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = 
            Result.success(false).publisher.eraseToAnyPublisher()
        mockFavouriteMoviesDao.whenInsert = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .addFavouriteMovie(movieDetail: expectedMovieDetail)
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
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(isFetchCompleted)
    }
    
    func test_addFavouriteMoviePreviouslyExist_deleteFavouriteMovie_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = 
            Result.success(true).publisher.eraseToAnyPublisher()
        mockFavouriteMoviesDao.whenDeleteFavouriteMovie = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .addFavouriteMovie(movieDetail: expectedMovieDetail)
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
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(isFetchCompleted)
    }
    
    func test_fetchAll_success() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        mockFavouriteMoviesDao.whenFetchAllFavouriteMovies = 
            Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut
            .fetchAllFavouriteMovies()
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { movies in
                    actualResult = movies
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(expectedNowPlayingMovies, actualResult)
    }
    
    func test_fetchAll_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockFavouriteMoviesDao.whenFetchAllFavouriteMovies = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchAllFavouriteMovies()
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
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(isFetchCompleted)
    }
    
    func test_doesFavouriteMovieExistPreviouslyExist_shouldReturnTrue() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var actualResult = false
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = 
            Result.success(true).publisher.eraseToAnyPublisher()
        
        sut
            .doesFavouriteMovieExist(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { result in
                    actualResult = result
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(actualResult)
    }
    
    func test_doesFavouriteMovieExistPreviouslyNotExist_shouldReturnFalse() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var actualResult = false
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = 
            Result.success(false).publisher.eraseToAnyPublisher()
        
        sut
            .doesFavouriteMovieExist(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { result in
                    actualResult = result
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(actualResult)
    }
    
    func test_doesFavouriteMovieExistPreviouslyNotExist_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockFavouriteMoviesDao.whenDoesFavouriteMovieExist = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .doesFavouriteMovieExist(movieId: movieId)
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
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(isFetchCompleted)
    }
}
