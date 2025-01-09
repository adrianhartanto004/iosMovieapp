import XCTest
import Combine
@testable import iosMovieapp

class MovieDetailViewModelTest: XCTestCase {
    private var mockFetchMovieDetailUsecase: MockFetchMovieDetailUsecase!
    private var mockGetMovieDetailUsecase: MockGetMovieDetailUsecase!
    private var mockFetchMovieCreditsUsecase: MockFetchMovieCreditsUsecase!
    private var mockGetMovieCastsUsecase: MockGetMovieCastsUsecase!
    private var mockFetchMoviePhotosUsecase: MockFetchMoviePhotosUsecase!
    private var mockGetMoviePhotosUsecase: MockGetMoviePhotosUsecase!
    private var mockFetchAuthorReviewsUsecase: MockFetchAuthorReviewsUsecase!
    private var mockGetAuthorReviewsUsecase: MockGetAuthorReviewsUsecase!
    private var mockAddOrRemoveFavouriteMovieUsecase: MockAddOrRemoveFavouriteMovieUsecase!
    private var mockGetIsFavouriteMovieUsecase: MockGetIsFavouriteMovieUsecase!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: MovieDetailViewModel!
    
    override func setUp() {
        mockFetchMovieDetailUsecase = MockFetchMovieDetailUsecase()
        mockGetMovieDetailUsecase = MockGetMovieDetailUsecase()
        mockFetchMovieCreditsUsecase = MockFetchMovieCreditsUsecase()
        mockGetMovieCastsUsecase = MockGetMovieCastsUsecase()
        mockFetchMoviePhotosUsecase = MockFetchMoviePhotosUsecase()
        mockGetMoviePhotosUsecase = MockGetMoviePhotosUsecase()
        mockFetchAuthorReviewsUsecase = MockFetchAuthorReviewsUsecase()
        mockGetAuthorReviewsUsecase = MockGetAuthorReviewsUsecase()
        mockAddOrRemoveFavouriteMovieUsecase = MockAddOrRemoveFavouriteMovieUsecase()
        mockGetIsFavouriteMovieUsecase = MockGetIsFavouriteMovieUsecase()
        
        sut = MovieDetailViewModel(
            mockFetchMovieDetailUsecase, 
            mockGetMovieDetailUsecase, 
            mockFetchMovieCreditsUsecase, 
            mockGetMovieCastsUsecase, 
            mockFetchMoviePhotosUsecase, 
            mockGetMoviePhotosUsecase, 
            mockFetchAuthorReviewsUsecase,
            mockGetAuthorReviewsUsecase,
            mockAddOrRemoveFavouriteMovieUsecase,
            mockGetIsFavouriteMovieUsecase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockFetchMovieDetailUsecase = nil
        mockGetMovieDetailUsecase = nil
        mockFetchMovieCreditsUsecase = nil
        mockGetMovieCastsUsecase = nil
        mockFetchMoviePhotosUsecase = nil
        mockGetMoviePhotosUsecase = nil
        mockFetchAuthorReviewsUsecase = nil
        mockGetAuthorReviewsUsecase = nil
        mockAddOrRemoveFavouriteMovieUsecase = nil
        mockGetIsFavouriteMovieUsecase = nil
    }
    
    func test_fetchMovieDetail_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedIsFavouriteMovie = Bool.random()
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let refreshingExp = XCTestExpectation(description: #function)
        let movieDetailExp = XCTestExpectation(description: #function)
        let isFavouriteMovieExp = XCTestExpectation(description: #function)
        var movieDetailResult: MovieDetail?
        var isFavouriteMovieResult = false
        
        mockFetchMovieDetailUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetMovieDetailUsecase.whenExecute = Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        mockGetIsFavouriteMovieUsecase.whenExecute = Result.success(expectedIsFavouriteMovie).publisher.eraseToAnyPublisher()
        
        sut.fetchMovieDetail(movieId: movieId)
        XCTAssertTrue(sut.isMovieDetailRefreshing)
        XCTAssertNil(sut.movieDetailError)
        
        sut.$isMovieDetailRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$movieDetail
            .dropFirst()
            .sink { movieDetail in
                movieDetailResult = movieDetail
                XCTAssertNil(self.sut.movieDetailError)
                movieDetailExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isFavouriteMovie
            .dropFirst()
            .sink { isFavourite in
                isFavouriteMovieResult = isFavourite
                XCTAssertNil(self.sut.movieDetailError)
                isFavouriteMovieExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshingExp, movieDetailExp, isFavouriteMovieExp], timeout: 5)
        
        XCTAssertEqual(expectedMovieDetail, movieDetailResult)
        XCTAssertEqual(expectedIsFavouriteMovie, isFavouriteMovieResult)
    }
    
    func test_fetchMovieDetail_fetchError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchMovieDetailUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchMovieDetail(movieId: movieId)
        XCTAssertTrue(sut.isMovieDetailRefreshing)
        XCTAssertNil(sut.movieDetailError)
        
        sut.$movieDetailError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieDetailRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieDetailError)
    }
    
    func test_fetchMovieDetail_getMovieDetailError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchMovieDetailUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetMovieDetailUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchMovieDetail(movieId: movieId)
        XCTAssertTrue(sut.isMovieDetailRefreshing)
        XCTAssertNil(sut.movieDetailError)
        
        sut.$movieDetailError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieDetailRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieDetailError)
    }
    
    func test_fetchMovieDetail_getIsFavouriteMovieError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let movieDetailExp = XCTestExpectation(description: #function)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        var movieDetailResult: MovieDetail?
        let error = NSError.test
        
        mockFetchMovieDetailUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetMovieDetailUsecase.whenExecute = Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        mockGetIsFavouriteMovieUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchMovieDetail(movieId: movieId)
        XCTAssertTrue(sut.isMovieDetailRefreshing)
        XCTAssertNil(sut.movieDetailError)
        
        sut.$movieDetail
            .dropFirst()
            .sink { movieDetail in
                movieDetailResult = movieDetail
                XCTAssertNil(self.sut.movieDetailError)
                movieDetailExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$movieDetailError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieDetailRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [movieDetailExp, errorExp, refreshingExp], timeout: 5)
        
        XCTAssertEqual(expectedMovieDetail, movieDetailResult)
        XCTAssertNotNil(sut.movieDetailError)
    }
    
    func test_loadMovieDetail_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedIsFavouriteMovie = Bool.random()
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let loadingExp = XCTestExpectation(description: #function)
        let movieDetailExp = XCTestExpectation(description: #function)
        let isFavouriteMovieExp = XCTestExpectation(description: #function)
        var movieDetailResult: MovieDetail?
        var isFavouriteMovieResult = false
        
        mockGetMovieDetailUsecase.whenExecute = Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        mockGetIsFavouriteMovieUsecase.whenExecute = Result.success(expectedIsFavouriteMovie).publisher.eraseToAnyPublisher()
        
        sut.loadMovieDetail(movieId: movieId)
        XCTAssertTrue(sut.isMovieDetailLoading)
        XCTAssertNil(sut.movieDetailError)
        
        sut.$isMovieDetailLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$movieDetail
            .dropFirst()
            .sink { movieDetail in
                movieDetailResult = movieDetail
                XCTAssertNil(self.sut.movieDetailError)
                movieDetailExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isFavouriteMovie
            .dropFirst()
            .sink { isFavourite in
                isFavouriteMovieResult = isFavourite
                XCTAssertNil(self.sut.movieDetailError)
                isFavouriteMovieExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadingExp, movieDetailExp, isFavouriteMovieExp], timeout: 5)
        
        XCTAssertEqual(expectedMovieDetail, movieDetailResult)
        XCTAssertEqual(expectedIsFavouriteMovie, isFavouriteMovieResult)
    }
    
    func test_loadMovieDetail_getMovieDetailError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let loadingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockGetMovieDetailUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadMovieDetail(movieId: movieId)
        XCTAssertTrue(sut.isMovieDetailLoading)
        XCTAssertNil(sut.movieDetailError)
        
        sut.$movieDetailError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieDetailLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, loadingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieDetailError)
    }
    
    func test_loadMovieDetail_getIsFavouriteMovieError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let movieDetailExp = XCTestExpectation(description: #function)
        let errorExp = XCTestExpectation(description: #function)
        let loadingExp = XCTestExpectation(description: #function)
        var movieDetailResult: MovieDetail?
        let error = NSError.test
        
        mockGetMovieDetailUsecase.whenExecute = Result.success(expectedMovieDetail).publisher.eraseToAnyPublisher()
        mockGetIsFavouriteMovieUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadMovieDetail(movieId: movieId)
        XCTAssertTrue(sut.isMovieDetailLoading)
        XCTAssertNil(sut.movieDetailError)
        
        sut.$movieDetail
            .dropFirst()
            .sink { movieDetail in
                movieDetailResult = movieDetail
                XCTAssertNil(self.sut.movieDetailError)
                movieDetailExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$movieDetailError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieDetailLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [movieDetailExp, errorExp, loadingExp], timeout: 5)
        
        XCTAssertEqual(expectedMovieDetail, movieDetailResult)
        XCTAssertNotNil(sut.movieDetailError)
    }
    
    func test_fetchMovieCredits_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieCasts = [createCast(), createCast(), createCast()]
        let refreshingExp = XCTestExpectation(description: #function)
        let movieCastsExp = XCTestExpectation(description: #function)
        var castsResult: [Cast] = []
        
        mockFetchMovieCreditsUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetMovieCastsUsecase.whenExecute = Result.success(expectedMovieCasts).publisher.eraseToAnyPublisher()
        
        sut.fetchMovieCasts(movieId: movieId)
        XCTAssertTrue(sut.isMovieCastsRefreshing)
        XCTAssertNil(sut.movieCastsError)
        
        sut.$isMovieCastsRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$movieCasts
            .dropFirst()
            .sink { casts in
                castsResult = casts
                XCTAssertNil(self.sut.movieCastsError)
                movieCastsExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshingExp, movieCastsExp], timeout: 5)
        
        XCTAssertEqual(expectedMovieCasts, castsResult)
    }
    
    func test_fetchMovieCredits_fetchCastsError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchMovieCreditsUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchMovieCasts(movieId: movieId)
        XCTAssertTrue(sut.isMovieCastsRefreshing)
        XCTAssertNil(sut.movieCastsError)
        
        sut.$movieCastsError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieCastsRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieCastsError)
    }
    
    func test_fetchMovieCredits_getMovieCastsError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchMovieCreditsUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetMovieCastsUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchMovieCasts(movieId: movieId)
        XCTAssertTrue(sut.isMovieCastsRefreshing)
        XCTAssertNil(sut.movieCastsError)
        
        sut.$movieCastsError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieCastsRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieCastsError)
    }
    
    func test_loadMovieCasts_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieCasts = [createCast(), createCast(), createCast()]
        let loadingExp = XCTestExpectation(description: #function)
        let movieCastsExp = XCTestExpectation(description: #function)
        var castsResult: [Cast] = []
        
        mockGetMovieCastsUsecase.whenExecute = Result.success(expectedMovieCasts).publisher.eraseToAnyPublisher()
        
        sut.loadMovieCasts(movieId: movieId)
        XCTAssertTrue(sut.isMovieCastsLoading)
        XCTAssertNil(sut.movieCastsError)
        
        sut.$isMovieCastsLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$movieCasts
            .dropFirst()
            .sink { casts in
                castsResult = casts
                XCTAssertNil(self.sut.movieCastsError)
                movieCastsExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadingExp, movieCastsExp], timeout: 5)
        
        XCTAssertEqual(expectedMovieCasts, castsResult)
    }
    
    func test_loadMovieCasts_error() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let loadingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockGetMovieCastsUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadMovieCasts(movieId: movieId)
        XCTAssertTrue(sut.isMovieCastsLoading)
        XCTAssertNil(sut.movieCastsError)
        
        sut.$movieCastsError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieCastsLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, loadingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieCastsError)
    }
    
    func test_fetchMoviePhotos_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMoviePhotos = [createPhotos(), createPhotos(), createPhotos()]
        let refreshingExp = XCTestExpectation(description: #function)
        let moviePhotosExp = XCTestExpectation(description: #function)
        var moviePhotosResult: [Photo] = []
        
        mockFetchMoviePhotosUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetMoviePhotosUsecase.whenExecute = Result.success(expectedMoviePhotos).publisher.eraseToAnyPublisher()
        
        sut.fetchMoviePhotos(movieId: movieId)
        XCTAssertTrue(sut.isMoviePhotosRefreshing)
        XCTAssertNil(sut.moviePhotosError)
        
        sut.$isMoviePhotosRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$moviePhotos
            .dropFirst()
            .sink { photos in
                moviePhotosResult = photos
                XCTAssertNil(self.sut.moviePhotosError)
                moviePhotosExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshingExp, moviePhotosExp], timeout: 5)
        
        XCTAssertEqual(expectedMoviePhotos, moviePhotosResult)
    }
    
    func test_fetchMoviePhotos_fetchPhotosError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchMoviePhotosUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchMoviePhotos(movieId: movieId)
        XCTAssertTrue(sut.isMoviePhotosRefreshing)
        XCTAssertNil(sut.moviePhotosError)
        
        sut.$moviePhotosError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMoviePhotosRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.moviePhotosError)
    }
    
    func test_fetchMoviePhotos_getMoviePhotosError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchMoviePhotosUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetMoviePhotosUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchMoviePhotos(movieId: movieId)
        XCTAssertTrue(sut.isMoviePhotosRefreshing)
        XCTAssertNil(sut.moviePhotosError)
        
        sut.$moviePhotosError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMoviePhotosRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.moviePhotosError)
    }
    
    func test_loadMoviePhotos_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMoviePhotos = [createPhotos(), createPhotos(), createPhotos()]
        let loadingExp = XCTestExpectation(description: #function)
        let moviePhotosExp = XCTestExpectation(description: #function)
        var moviePhotosResult: [Photo] = []
        
        mockGetMoviePhotosUsecase.whenExecute = Result.success(expectedMoviePhotos).publisher.eraseToAnyPublisher()
        
        sut.loadMoviePhotos(movieId: movieId)
        XCTAssertTrue(sut.isMoviePhotosLoading)
        XCTAssertNil(sut.moviePhotosError)
        
        sut.$isMoviePhotosLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$moviePhotos
            .dropFirst()
            .sink { photos in
                moviePhotosResult = photos
                XCTAssertNil(self.sut.moviePhotosError)
                moviePhotosExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadingExp, moviePhotosExp], timeout: 5)
        
        XCTAssertEqual(expectedMoviePhotos, moviePhotosResult)
    }
    
    func test_loadMoviePhotos_error() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let loadingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockGetMoviePhotosUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadMoviePhotos(movieId: movieId)
        XCTAssertTrue(sut.isMoviePhotosLoading)
        XCTAssertNil(sut.moviePhotosError)
        
        sut.$moviePhotosError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMoviePhotosLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, loadingExp], timeout: 5)
        
        XCTAssertNotNil(sut.moviePhotosError)
    }
    
    func test_fetchAuthorReviews_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedAuthorReviews = [createAuthorReview(), createAuthorReview(), createAuthorReview()]
        let refreshingExp = XCTestExpectation(description: #function)
        let authorReviewsExp = XCTestExpectation(description: #function)
        var authorReviewsResult: [AuthorReview] = []
        
        mockFetchAuthorReviewsUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetAuthorReviewsUsecase.whenExecute = Result.success(expectedAuthorReviews).publisher.eraseToAnyPublisher()
        
        sut.fetchAuthorReviews(movieId: movieId)
        XCTAssertTrue(sut.isMovieAuthorReviewsRefreshing)
        XCTAssertNil(sut.movieAuthorReviewsError)
        
        sut.$isMovieAuthorReviewsRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$authorReviews
            .dropFirst()
            .sink { authorReviews in
                authorReviewsResult = authorReviews
                XCTAssertNil(self.sut.movieAuthorReviewsError)
                authorReviewsExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshingExp, authorReviewsExp], timeout: 5)
        
        XCTAssertEqual(expectedAuthorReviews, authorReviewsResult)
    }
    
    func test_fetchAuthorReviews_fetchAuthorReviewsError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchAuthorReviewsUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchAuthorReviews(movieId: movieId)
        XCTAssertTrue(sut.isMovieAuthorReviewsRefreshing)
        XCTAssertNil(sut.movieAuthorReviewsError)
        
        sut.$movieAuthorReviewsError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieAuthorReviewsRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieAuthorReviewsError)
    }
    
    func test_fetchAuthorReviews_getAuthorReviewsError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchAuthorReviewsUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetAuthorReviewsUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchAuthorReviews(movieId: movieId)
        XCTAssertTrue(sut.isMovieAuthorReviewsRefreshing)
        XCTAssertNil(sut.movieAuthorReviewsError)
        
        sut.$movieAuthorReviewsError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieAuthorReviewsRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieAuthorReviewsError)
    }
    
    func test_loadAuthorReviews_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedAuthorReviews = [createAuthorReview(), createAuthorReview(), createAuthorReview()]
        let loadingExp = XCTestExpectation(description: #function)
        let authorReviewsExp = XCTestExpectation(description: #function)
        var authorReviewsResult: [AuthorReview] = []
        
        mockGetAuthorReviewsUsecase.whenExecute = Result.success(expectedAuthorReviews).publisher.eraseToAnyPublisher()
        
        sut.loadAuthorReviews(movieId: movieId)
        XCTAssertTrue(sut.isMovieAuthorReviewsLoading)
        XCTAssertNil(sut.movieAuthorReviewsError)
        
        sut.$isMovieAuthorReviewsLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$authorReviews
            .dropFirst()
            .sink { authorReviews in
                authorReviewsResult = authorReviews
                XCTAssertNil(self.sut.movieAuthorReviewsError)
                authorReviewsExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadingExp, authorReviewsExp], timeout: 5)
        
        XCTAssertEqual(expectedAuthorReviews, authorReviewsResult)
    }
    
    func test_loadAuthorReviews_error() throws {
        let movieId = Int.random(in: 1...100)
        let errorExp = XCTestExpectation(description: #function)
        let loadingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockGetAuthorReviewsUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadAuthorReviews(movieId: movieId)
        XCTAssertTrue(sut.isMovieAuthorReviewsLoading)
        XCTAssertNil(sut.movieAuthorReviewsError)
        
        sut.$movieAuthorReviewsError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isMovieAuthorReviewsLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, loadingExp], timeout: 5)
        
        XCTAssertNotNil(sut.movieAuthorReviewsError)
    }
    
    func test_addOrRemoveFavouriteMovie_shouldReturnResult() throws {
        let movieId = Int.random(in: 1...100)
        let expectedAddOrRemoveFavouriteMovie = Bool.random()
        let movieDetail = createMovieDetail(movieId: movieId)
        let addOrRemoveFavouriteMovieExp = XCTestExpectation(description: #function)
        var addOrRemoveFavouriteMovieResult = false
        
        mockAddOrRemoveFavouriteMovieUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetIsFavouriteMovieUsecase.whenExecute = Result.success(expectedAddOrRemoveFavouriteMovie).publisher.eraseToAnyPublisher()
        
        sut.addOrRemoveFavouriteMovie(movieDetail: movieDetail)
        XCTAssertNil(sut.addOrRemoveFavouriteMovieError)
        
        sut.$isFavouriteMovie
            .dropFirst()
            .sink { result in
                addOrRemoveFavouriteMovieResult = result
                XCTAssertNil(self.sut.addOrRemoveFavouriteMovieError)
                addOrRemoveFavouriteMovieExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [addOrRemoveFavouriteMovieExp], timeout: 5)
        
        XCTAssertEqual(expectedAddOrRemoveFavouriteMovie, addOrRemoveFavouriteMovieResult)
    }
    
    func test_addOrRemoveFavouriteMovie_addOrRemoveError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let movieDetail = createMovieDetail(movieId: movieId)
        let errorExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockAddOrRemoveFavouriteMovieUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.addOrRemoveFavouriteMovie(movieDetail: movieDetail)
        XCTAssertNil(sut.addOrRemoveFavouriteMovieError)
        
        sut.$addOrRemoveFavouriteMovieError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp], timeout: 5)
        
        XCTAssertNotNil(sut.addOrRemoveFavouriteMovieError)
    }
    
    func test_addOrRemoveFavouriteMovie_getIsFavouriteMovieError_shouldReturnError() throws {
        let movieId = Int.random(in: 1...100)
        let movieDetail = createMovieDetail(movieId: movieId)
        let errorExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockAddOrRemoveFavouriteMovieUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetIsFavouriteMovieUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.addOrRemoveFavouriteMovie(movieDetail: movieDetail)
        XCTAssertNil(sut.addOrRemoveFavouriteMovieError)
        
        sut.$addOrRemoveFavouriteMovieError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp], timeout: 5)
        
        XCTAssertNotNil(sut.addOrRemoveFavouriteMovieError)
    }
}
