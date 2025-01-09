import XCTest
import Combine
@testable import iosMovieapp

class MovieRepositoryTest: XCTestCase {
    private var mockNowPlayingMoviesService: MockNowPlayingMoviesService!
    private var mockNowPlayingMoviesDao: MockNowPlayingMoviesDao!
    private var mockMovieDetailService: MockMovieDetailService!
    private var mockMovieDetailDao: MockMovieDetailDao!
    private var mockMovieCastsDao: MockMovieCastsDao!
    private var mockMoviePhotosDao: MockMoviePhotosDao!
    private var mockMovieAuthorReviewsDao: MockMovieAuthorReviewsDao!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: MovieRepository!
    
    override func setUp() {
        mockNowPlayingMoviesService = MockNowPlayingMoviesService()
        mockNowPlayingMoviesDao = MockNowPlayingMoviesDao()
        mockMovieDetailService = MockMovieDetailService()
        mockMovieDetailDao = MockMovieDetailDao()
        mockMovieCastsDao = MockMovieCastsDao()
        mockMoviePhotosDao = MockMoviePhotosDao()
        mockMovieAuthorReviewsDao = MockMovieAuthorReviewsDao()
        
        sut = MovieRepositoryImpl(
            nowPlayingMoviesService: mockNowPlayingMoviesService,
            nowPlayingMoviesDao: mockNowPlayingMoviesDao,
            movieDetailService: mockMovieDetailService,
            movieDetailDao: mockMovieDetailDao,
            movieCastsDao: mockMovieCastsDao,
            moviePhotosDao: mockMoviePhotosDao,
            movieAuthorReviewsDao: mockMovieAuthorReviewsDao
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNowPlayingMoviesService = nil
        mockNowPlayingMoviesDao = nil
        mockMovieDetailService = nil
        mockMovieDetailDao = nil
        mockMovieCastsDao = nil
        mockMoviePhotosDao = nil
        mockMovieAuthorReviewsDao = nil
    }
    
    func test_fetchNowPlayingMovies_success() throws {
        let expectedNowPlayingMoviesList = createNowPlayingMoviesList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        
        mockNowPlayingMoviesService.whenFetchedResult = 
            Result.success(expectedNowPlayingMoviesList).publisher.eraseToAnyPublisher()
        mockNowPlayingMoviesDao.whenDeleteAll = Result.success(()).publisher.eraseToAnyPublisher()
        mockNowPlayingMoviesDao.whenInsertAll = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .fetchNowPlayingMovies()
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isFetchCompleted)
    }
    
    func test_fetchNowPlayingMovies_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = APIError.noNetwork
        
        mockNowPlayingMoviesService.whenFetchedResult = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchNowPlayingMovies()
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
    
    func test_fetchNowPlayingMovies_deleteDatabase_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        let expectedNowPlayingMoviesList = createNowPlayingMoviesList()
        
        mockNowPlayingMoviesService.whenFetchedResult = Result.success(expectedNowPlayingMoviesList).publisher.eraseToAnyPublisher()
        mockNowPlayingMoviesDao.whenDeleteAll =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchNowPlayingMovies()
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
    
    func test_fetchNowPlayingMovies_insertAll_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        let expectedNowPlayingMoviesList = createNowPlayingMoviesList()
        
        mockNowPlayingMoviesService.whenFetchedResult = Result.success(expectedNowPlayingMoviesList).publisher.eraseToAnyPublisher()
        mockNowPlayingMoviesDao.whenDeleteAll =
            Result.success(()).publisher.eraseToAnyPublisher()
        mockNowPlayingMoviesDao.whenInsertAll =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchNowPlayingMovies()
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
    
    func test_loadMoreNowPlayingMovies_success() throws {
        let expectedNowPlayingMoviesList = createNowPlayingMoviesList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        
        mockNowPlayingMoviesService.whenFetchedResult = 
            Result.success(expectedNowPlayingMoviesList).publisher.eraseToAnyPublisher()
        mockNowPlayingMoviesDao.whenInsertAll = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .loadMoreNowPlayingMovies(page: 1)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isFetchCompleted)
    }
    
    func test_loadMoreNowPlayingMovies_fetch_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockNowPlayingMoviesService.whenFetchedResult = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .loadMoreNowPlayingMovies(page: 1)
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
    
    func test_loadMoreNowPlayingMovies_insertAll_error() throws {
        let expectedNowPlayingMoviesList = createNowPlayingMoviesList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockNowPlayingMoviesService.whenFetchedResult = 
            Result.success(expectedNowPlayingMoviesList).publisher.eraseToAnyPublisher()
        mockNowPlayingMoviesDao.whenInsertAll = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .loadMoreNowPlayingMovies(page: 1)
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
    
    func test_getNowPlayingMovies_shouldReturnData() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)),
            createNowPlayingMovies(movieId: Int.random(in: 1...100)),
            createNowPlayingMovies(movieId: Int.random(in: 1...100)),
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        mockNowPlayingMoviesDao.whenFetch = Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut
            .getNowPlayingMovies(limit: nil)
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
    
    func test_getNowPlayingMovies_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockNowPlayingMoviesDao.whenFetch =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .getNowPlayingMovies(limit: nil)
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
    
    func test_fetchMovieDetail_success() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        
        mockMovieDetailService.whenFetchMovieDetail = Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        mockMovieDetailDao.whenDeleteMovieDetail = Result.success(()).publisher.eraseToAnyPublisher()
        mockMovieDetailDao.whenInsert = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieDetail(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isFetchCompleted)
    }
    
    func test_fetchMovieDetail_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = APIError.noNetwork
        
        mockMovieDetailService.whenFetchMovieDetail =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieDetail(movieId: movieId)
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
    
    func test_fetchMovieDetail_deleteDatabase_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        
        mockMovieDetailService.whenFetchMovieDetail = Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        mockMovieDetailDao.whenDeleteMovieDetail =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieDetail(movieId: movieId)
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
    
    func test_fetchMovieDetail_insertAll_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        
        mockMovieDetailService.whenFetchMovieDetail = Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        mockMovieDetailDao.whenDeleteMovieDetail =
            Result.success(()).publisher.eraseToAnyPublisher()
        mockMovieDetailDao.whenInsert =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieDetail(movieId: movieId)
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
    
    func test_getMovieDetail_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let exp = XCTestExpectation(description: #function)
        var actualResult: MovieDetail?
        
        mockMovieDetailDao.whenFetch = 
            Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        
        sut
            .getMovieDetail(movieId: movieId)
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
    
    func test_getMovieDetail_error() throws {
        let movieId = Int.random(in: 1...100)        
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieDetailDao.whenFetch =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .getMovieDetail(movieId: movieId)
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
    
    func test_fetchMovieCasts_success() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMovieCreditList = createMovieCreditList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        
        mockMovieDetailService.whenFetchMovieCredits = Result.success(expectedMovieCreditList).publisher.eraseToAnyPublisher()
        mockMovieCastsDao.whenDeleteMovieCredits = Result.success(()).publisher.eraseToAnyPublisher()
        mockMovieCastsDao.whenInsertAll = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieCredits(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isFetchCompleted)
    }
    
    func test_fetchMovieCasts_error() throws {
        let movieId = Int.random(in: 1...100)        
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = APIError.noNetwork
        
        mockMovieDetailService.whenFetchMovieCredits =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieCredits(movieId: movieId)
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
    
    func test_fetchMovieCasts_deleteDatabase_error() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMovieCreditList = createMovieCreditList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieDetailService.whenFetchMovieCredits = Result.success(expectedMovieCreditList).publisher.eraseToAnyPublisher()
        mockMovieCastsDao.whenDeleteMovieCredits =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieCredits(movieId: movieId)
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
    
    func test_fetchMovieCasts_insertAll_error() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMovieCreditList = createMovieCreditList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieDetailService.whenFetchMovieCredits = Result.success(expectedMovieCreditList).publisher.eraseToAnyPublisher()
        mockMovieCastsDao.whenDeleteMovieCredits =
            Result.success(()).publisher.eraseToAnyPublisher()
        mockMovieCastsDao.whenInsertAll =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMovieCredits(movieId: movieId)
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
    
    func test_getMovieCasts_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMovieCasts = [createCast(), createCast(), createCast()]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [Cast] = []
        
        mockMovieCastsDao.whenFetch = 
            Result.success(expectedMovieCasts).publisher.eraseToAnyPublisher()
        
        sut
            .getMovieCasts(movieId: movieId)
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
        
        XCTAssertEqual(expectedMovieCasts, actualResult)
    }
    
    func test_getMovieCasts_error() throws {
        let movieId = Int.random(in: 1...100)        
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieCastsDao.whenFetch =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .getMovieCasts(movieId: movieId)
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
    
    func test_fetchMoviePhotos_success() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMoviePhotoList = createMoviePhotoList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        
        mockMovieDetailService.whenFetchMoviePhotos = Result.success(expectedMoviePhotoList).publisher.eraseToAnyPublisher()
        mockMoviePhotosDao.whenDeleteMoviePhoto = Result.success(()).publisher.eraseToAnyPublisher()
        mockMoviePhotosDao.whenInsertAll = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMoviePhotos(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isFetchCompleted)
    }
    
    func test_fetchMoviePhotos_error() throws {
        let movieId = Int.random(in: 1...100)        
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = APIError.noNetwork
        
        mockMovieDetailService.whenFetchMoviePhotos =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMoviePhotos(movieId: movieId)
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
    
    func test_fetchMoviePhotos_deleteDatabase_error() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMoviePhotoList = createMoviePhotoList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieDetailService.whenFetchMoviePhotos = Result.success(expectedMoviePhotoList).publisher.eraseToAnyPublisher()
        mockMoviePhotosDao.whenDeleteMoviePhoto =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMoviePhotos(movieId: movieId)
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
    
    func test_fetchMoviePhotos_insertAll_error() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMoviePhotoList = createMoviePhotoList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieDetailService.whenFetchMoviePhotos = Result.success(expectedMoviePhotoList).publisher.eraseToAnyPublisher()
        mockMoviePhotosDao.whenDeleteMoviePhoto =
            Result.success(()).publisher.eraseToAnyPublisher()
        mockMoviePhotosDao.whenInsertAll =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchMoviePhotos(movieId: movieId)
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
    
    func test_getMoviePhotos_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedMoviePhotos = [createPhotos(), createPhotos(), createPhotos()]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [Photo] = []
        
        mockMoviePhotosDao.whenFetch = 
            Result.success(expectedMoviePhotos).publisher.eraseToAnyPublisher()
        
        sut
            .getMoviePhotos(movieId: movieId)
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
        
        XCTAssertEqual(expectedMoviePhotos, actualResult)
    }
    
    func test_getMoviePhotos_error() throws {
        let movieId = Int.random(in: 1...100)        
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMoviePhotosDao.whenFetch =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .getMoviePhotos(movieId: movieId)
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
    
    func test_fetchAuthorReviews_success() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedAuthorReviewList = createAuthorReviewList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        
        mockMovieDetailService.whenFetchAuthorReviews = Result.success(expectedAuthorReviewList).publisher.eraseToAnyPublisher()
        mockMovieAuthorReviewsDao.whenDeleteMovieAuthorReviews = Result.success(()).publisher.eraseToAnyPublisher()
        mockMovieAuthorReviewsDao.whenInsertAll = Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .fetchAuthorReviews(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isFetchCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isFetchCompleted)
    }
    
    func test_fetchAuthorReviews_error() throws {
        let movieId = Int.random(in: 1...100)        
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = APIError.noNetwork
        
        mockMovieDetailService.whenFetchAuthorReviews =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchAuthorReviews(movieId: movieId)
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
    
    func test_fetchAuthorReviews_deleteDatabase_error() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedAuthorReviewList = createAuthorReviewList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieDetailService.whenFetchAuthorReviews = Result.success(expectedAuthorReviewList).publisher.eraseToAnyPublisher()
        mockMovieAuthorReviewsDao.whenDeleteMovieAuthorReviews =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchAuthorReviews(movieId: movieId)
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
    
    func test_fetchAuthorReviews_insertAll_error() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedAuthorReviewList = createAuthorReviewList()
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieDetailService.whenFetchAuthorReviews = Result.success(expectedAuthorReviewList).publisher.eraseToAnyPublisher()
        mockMovieAuthorReviewsDao.whenDeleteMovieAuthorReviews =
            Result.success(()).publisher.eraseToAnyPublisher()
        mockMovieAuthorReviewsDao.whenInsertAll =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .fetchAuthorReviews(movieId: movieId)
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
    
    func test_getAuthorReviews_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)        
        let expectedAuthorReviews = [createAuthorReview(), createAuthorReview(), createAuthorReview()]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [AuthorReview] = []
        
        mockMovieAuthorReviewsDao.whenFetch = 
            Result.success(expectedAuthorReviews).publisher.eraseToAnyPublisher()
        
        sut
            .getAuthorReviews(movieId: movieId)
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
    
    func test_getAuthorReviews_error() throws {
        let movieId = Int.random(in: 1...100)        
        let exp = XCTestExpectation(description: #function)
        var isFetchCompleted: Bool = false
        let error = CoreDataError.dataNotAvailable
        
        mockMovieAuthorReviewsDao.whenFetch =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .getAuthorReviews(movieId: movieId)
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
