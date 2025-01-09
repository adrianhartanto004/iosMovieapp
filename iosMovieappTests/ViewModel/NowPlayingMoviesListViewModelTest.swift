import XCTest
import Combine
@testable import iosMovieapp

class NowPlayingMoviesListViewModelTest: XCTestCase {
    private var mockFetchNowPlayingMoviesUsecase: MockFetchNowPlayingMoviesUsecase!
    private var mockGetNowPlayingMoviesUsecase: MockGetNowPlayingMoviesUsecase!
    private var mockLoadMoreNowPlayingMoviesUsecase: MockLoadMoreNowPlayingMoviesUsecase!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: NowPlayingMoviesListViewModel!
    
    override func setUp() {
        mockFetchNowPlayingMoviesUsecase = MockFetchNowPlayingMoviesUsecase()
        mockGetNowPlayingMoviesUsecase = MockGetNowPlayingMoviesUsecase()
        mockLoadMoreNowPlayingMoviesUsecase = MockLoadMoreNowPlayingMoviesUsecase()
        sut = NowPlayingMoviesListViewModel(
            mockFetchNowPlayingMoviesUsecase,
            mockGetNowPlayingMoviesUsecase,
            mockLoadMoreNowPlayingMoviesUsecase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockFetchNowPlayingMoviesUsecase = nil
        mockGetNowPlayingMoviesUsecase = nil
        mockLoadMoreNowPlayingMoviesUsecase = nil
    }
    
    func test_fetchNowPlayingMovies_shouldReturnData() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100))
        ]
        let expectedBottomNowPlayingMoviesItem = expectedNowPlayingMovies.last
        let refreshingExp = XCTestExpectation(description: #function)
        let nowPlayingMoviesExp = XCTestExpectation(description: #function)
        let bottomNowPlayingMoviesItemExp = XCTestExpectation(description: #function)
        var nowPlayingMoviesResult: [NowPlayingMovies] = []
        var bottomNowPlayingMoviesItemResult: NowPlayingMovies!
        
        mockFetchNowPlayingMoviesUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetNowPlayingMoviesUsecase.whenExecute = Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut.fetchNowPlayingMovies()
        XCTAssertTrue(sut.isNowPlayingMoviesRefreshing)
        XCTAssertNil(sut.moviesError)
        
        sut.$isNowPlayingMoviesRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$nowPlayingMovies
            .dropFirst()
            .sink { nowPlayingMovies in
                nowPlayingMoviesResult = nowPlayingMovies
                XCTAssertNil(self.sut.moviesError)
                nowPlayingMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$bottomNowPlayingMoviesItem
            .dropFirst()
            .sink { bottomMovieItem in
                bottomNowPlayingMoviesItemResult = bottomMovieItem
                XCTAssertNil(self.sut.moviesError)
                bottomNowPlayingMoviesItemExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshingExp, nowPlayingMoviesExp, bottomNowPlayingMoviesItemExp], timeout: 5)
        
        XCTAssertEqual(expectedNowPlayingMovies, nowPlayingMoviesResult)
        XCTAssertEqual(expectedBottomNowPlayingMoviesItem, bottomNowPlayingMoviesItemResult)
        XCTAssertTrue(sut.isFirstFetchSuccessful)
    }
    
    func test_fetchNowPlayingMovies_fetchError_shouldReturnError() throws {
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchNowPlayingMoviesUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchNowPlayingMovies()
        XCTAssertTrue(sut.isNowPlayingMoviesRefreshing)
        XCTAssertNil(sut.moviesError)
        
        sut.$moviesError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isNowPlayingMoviesRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.moviesError)
        XCTAssertNil(sut.bottomNowPlayingMoviesItem)
        XCTAssertFalse(sut.isFirstFetchSuccessful)
    }
    
    func test_fetchNowPlayingMovies_getMoviesError_shouldReturnerror() throws {
        let errorExp = XCTestExpectation(description: #function)
        let refreshingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockFetchNowPlayingMoviesUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetNowPlayingMoviesUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.fetchNowPlayingMovies()
        XCTAssertTrue(sut.isNowPlayingMoviesRefreshing)
        XCTAssertNil(sut.moviesError)
        
        sut.$moviesError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isNowPlayingMoviesRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, refreshingExp], timeout: 5)
        
        XCTAssertNotNil(sut.moviesError)
        XCTAssertNil(sut.bottomNowPlayingMoviesItem)
        XCTAssertFalse(sut.isFirstFetchSuccessful)
    }
    
    func test_loadNowPlayingMovies_shouldReturnData() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100))
        ]
        let expectedBottomNowPlayingMoviesItem = expectedNowPlayingMovies.last
        let loadingExp = XCTestExpectation(description: #function)
        let nowPlayingMoviesExp = XCTestExpectation(description: #function)
        let bottomNowPlayingMoviesItemExp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        var bottomNowPlayingMoviesItemResult: NowPlayingMovies!
        
        mockGetNowPlayingMoviesUsecase.whenExecute = Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut.loadNowPlayingMovies()
        XCTAssertTrue(sut.isNowPlayingMoviesLoading)
        XCTAssertNil(sut.moviesError)
        
        sut.$isNowPlayingMoviesLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$nowPlayingMovies
            .dropFirst()
            .sink { nowPlayingMovies in
                actualResult = nowPlayingMovies
                XCTAssertNil(self.sut.moviesError)
                nowPlayingMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$bottomNowPlayingMoviesItem
            .dropFirst()
            .sink { bottomMovieItem in
                bottomNowPlayingMoviesItemResult = bottomMovieItem
                XCTAssertNil(self.sut.moviesError)
                bottomNowPlayingMoviesItemExp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [loadingExp, nowPlayingMoviesExp], timeout: 5)

        XCTAssertEqual(expectedNowPlayingMovies, actualResult)
        XCTAssertEqual(expectedBottomNowPlayingMoviesItem, bottomNowPlayingMoviesItemResult)     
    }
    
    func test_loadNowPlayingMovies_getMoviesError_shouldReturnerror() throws {
        let errorExp = XCTestExpectation(description: #function)
        let loadingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockGetNowPlayingMoviesUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadNowPlayingMovies()
        XCTAssertTrue(sut.isNowPlayingMoviesLoading)
        XCTAssertNil(sut.moviesError)
        
        sut.$moviesError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isNowPlayingMoviesLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, loadingExp], timeout: 5)
        
        XCTAssertNotNil(sut.moviesError)
    }
    
    func test_loadMoreNowPlayingMovies_shouldReturnData() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1), 
            createNowPlayingMovies(movieId: 2), 
            createNowPlayingMovies(movieId: 3)
        ]
        var expectedBottomNowPlayingMoviesItem = expectedNowPlayingMovies.last
        let refreshingExp = XCTestExpectation(description: #function)
        let nowPlayingMoviesExp = XCTestExpectation(description: #function)
        let bottomNowPlayingMoviesItemExp = XCTestExpectation(description: #function)
        var nowPlayingMoviesResult: [NowPlayingMovies] = []
        var bottomNowPlayingMoviesItemResult: NowPlayingMovies!
        
        mockFetchNowPlayingMoviesUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetNowPlayingMoviesUsecase.whenExecute = Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut.fetchNowPlayingMovies()
        XCTAssertTrue(sut.isNowPlayingMoviesRefreshing)
        XCTAssertNil(sut.moviesError)
        
        sut.$isNowPlayingMoviesRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$nowPlayingMovies
            .dropFirst()
            .sink { nowPlayingMovies in
                nowPlayingMoviesResult = nowPlayingMovies
                XCTAssertNil(self.sut.moviesError)
                nowPlayingMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$bottomNowPlayingMoviesItem
            .dropFirst()
            .sink { bottomMovieItem in
                bottomNowPlayingMoviesItemResult = bottomMovieItem
                XCTAssertNil(self.sut.moviesError)
                bottomNowPlayingMoviesItemExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshingExp, nowPlayingMoviesExp, bottomNowPlayingMoviesItemExp], timeout: 5)
        
        XCTAssertEqual(expectedNowPlayingMovies, nowPlayingMoviesResult)
        XCTAssertEqual(expectedBottomNowPlayingMoviesItem, bottomNowPlayingMoviesItemResult)
        XCTAssertTrue(sut.isFirstFetchSuccessful)
        
        // start testing loadMore
        let loadMoreExpectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1), 
            createNowPlayingMovies(movieId: 2), 
            createNowPlayingMovies(movieId: 3),
            createNowPlayingMovies(movieId: 4), 
            createNowPlayingMovies(movieId: 5)
        ]
        expectedBottomNowPlayingMoviesItem = loadMoreExpectedNowPlayingMovies.last
        
        let loadMoreMoviesExp = XCTestExpectation(description: #function)
        let loadMoreNowPlayingMoviesExp = XCTestExpectation(description: #function)
        let loadMoreBottomNowPlayingMoviesItemExp = XCTestExpectation(description: #function)
        
        mockLoadMoreNowPlayingMoviesUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetNowPlayingMoviesUsecase.whenExecute = 
            Result.success(loadMoreExpectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut.loadMoreNowPlayingMovies()
        XCTAssertTrue(sut.isLoadMoreMoviesLoading)
        XCTAssertNil(sut.moviesError)
        
        sut.$isLoadMoreMoviesLoading
            .dropFirst()
            .sink { isLoadMoreLoading in
                XCTAssertFalse(isLoadMoreLoading)
                loadMoreMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$nowPlayingMovies
            .dropFirst()
            .sink { nowPlayingMovies in
                nowPlayingMoviesResult = nowPlayingMovies
                XCTAssertNil(self.sut.moviesError)
                loadMoreNowPlayingMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$bottomNowPlayingMoviesItem
            .dropFirst()
            .sink { bottomMovieItem in
                bottomNowPlayingMoviesItemResult = bottomMovieItem
                XCTAssertNil(self.sut.moviesError)
                loadMoreBottomNowPlayingMoviesItemExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadMoreMoviesExp, loadMoreNowPlayingMoviesExp, loadMoreBottomNowPlayingMoviesItemExp], timeout: 5)
        
        XCTAssertEqual(loadMoreExpectedNowPlayingMovies, nowPlayingMoviesResult)
        XCTAssertEqual(expectedBottomNowPlayingMoviesItem, bottomNowPlayingMoviesItemResult)
        XCTAssertTrue(sut.isFirstFetchSuccessful)
        XCTAssertEqual(sut.currentPage, 2)
    }
    
    func test_loadMoreNowPlayingMovies_fetchError_shouldReturnError() throws {
        let errorExp = XCTestExpectation(description: #function)
        let loadMoreMoviesLoadingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockLoadMoreNowPlayingMoviesUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadMoreNowPlayingMovies()
        XCTAssertTrue(sut.isLoadMoreMoviesLoading)
        XCTAssertNil(sut.loadMoreError)
        
        sut.$loadMoreError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isLoadMoreMoviesLoading
            .dropFirst()
            .sink { isLoadingMore in
                XCTAssertFalse(isLoadingMore)
                loadMoreMoviesLoadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, loadMoreMoviesLoadingExp], timeout: 5)
        
        XCTAssertNotNil(sut.loadMoreError)
        XCTAssertNil(sut.bottomNowPlayingMoviesItem)
        XCTAssertEqual(sut.currentPage, 1)
    }
    
    func test_loadMoreNowPlayingMovies_getMoviesError_shouldReturnError() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1), 
            createNowPlayingMovies(movieId: 2), 
            createNowPlayingMovies(movieId: 3)
        ]
        let expectedBottomNowPlayingMoviesItem = expectedNowPlayingMovies.last
        let refreshingExp = XCTestExpectation(description: #function)
        let nowPlayingMoviesExp = XCTestExpectation(description: #function)
        let bottomNowPlayingMoviesItemExp = XCTestExpectation(description: #function)
        var nowPlayingMoviesResult: [NowPlayingMovies] = []
        var bottomNowPlayingMoviesItemResult: NowPlayingMovies!
        
        mockFetchNowPlayingMoviesUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetNowPlayingMoviesUsecase.whenExecute = Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut.fetchNowPlayingMovies()
        XCTAssertTrue(sut.isNowPlayingMoviesRefreshing)
        XCTAssertNil(sut.moviesError)
        
        sut.$isNowPlayingMoviesRefreshing
            .dropFirst()
            .sink { isRefreshing in
                XCTAssertFalse(isRefreshing)
                refreshingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$nowPlayingMovies
            .dropFirst()
            .sink { nowPlayingMovies in
                nowPlayingMoviesResult = nowPlayingMovies
                XCTAssertNil(self.sut.moviesError)
                nowPlayingMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$bottomNowPlayingMoviesItem
            .dropFirst()
            .sink { bottomMovieItem in
                bottomNowPlayingMoviesItemResult = bottomMovieItem
                XCTAssertNil(self.sut.moviesError)
                bottomNowPlayingMoviesItemExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshingExp, nowPlayingMoviesExp, bottomNowPlayingMoviesItemExp], timeout: 5)
        
        XCTAssertEqual(expectedNowPlayingMovies, nowPlayingMoviesResult)
        XCTAssertEqual(expectedBottomNowPlayingMoviesItem, bottomNowPlayingMoviesItemResult)
        XCTAssertTrue(sut.isFirstFetchSuccessful)
        
        let loadMoreMoviesLoadingExp = XCTestExpectation(description: #function)
        let errorExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockLoadMoreNowPlayingMoviesUsecase.whenExecute = Result.success(()).publisher.eraseToAnyPublisher()
        mockGetNowPlayingMoviesUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadMoreNowPlayingMovies()
        XCTAssertTrue(sut.isLoadMoreMoviesLoading)
        XCTAssertNil(sut.moviesError)
        
        sut.$isLoadMoreMoviesLoading
            .dropFirst()
            .sink { isLoadMoreLoading in
                XCTAssertFalse(isLoadMoreLoading)
                loadMoreMoviesLoadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$loadMoreError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [
            loadMoreMoviesLoadingExp, 
            errorExp
        ], timeout: 5)
        
        XCTAssertEqual(expectedNowPlayingMovies, nowPlayingMoviesResult)
        XCTAssertEqual(expectedBottomNowPlayingMoviesItem, bottomNowPlayingMoviesItemResult)
        XCTAssertTrue(sut.isFirstFetchSuccessful)
        XCTAssertEqual(sut.currentPage, 1)
    }
}
