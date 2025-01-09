import XCTest
import Combine
@testable import iosMovieapp

class HomeViewModelTest: XCTestCase {
    private var mockFetchNowPlayingMoviesUsecase: MockFetchNowPlayingMoviesUsecase!
    private var mockGetNowPlayingMoviesUsecase: MockGetNowPlayingMoviesUsecase!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: HomeViewModel!
    
    override func setUp() {
        mockFetchNowPlayingMoviesUsecase = MockFetchNowPlayingMoviesUsecase()
        mockGetNowPlayingMoviesUsecase = MockGetNowPlayingMoviesUsecase()
        sut = HomeViewModel(
            mockFetchNowPlayingMoviesUsecase,
            mockGetNowPlayingMoviesUsecase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockFetchNowPlayingMoviesUsecase = nil
        mockGetNowPlayingMoviesUsecase = nil
    }
    
    func test_fetchNowPlayingMovies_shouldReturnData() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100))
        ]
        let refreshingExp = XCTestExpectation(description: #function)
        let nowPlayingMoviesExp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
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
                actualResult = nowPlayingMovies
                XCTAssertNil(self.sut.moviesError)
                nowPlayingMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [refreshingExp, nowPlayingMoviesExp], timeout: 5)
        
        XCTAssertEqual(expectedNowPlayingMovies, actualResult)
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
    }
    
    func test_loadNowPlayingMovies_shouldReturnData() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100))
        ]
        let loadingExp = XCTestExpectation(description: #function)
        let nowPlayingMoviesExp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
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
        wait(for: [loadingExp, nowPlayingMoviesExp], timeout: 5)
        
        XCTAssertEqual(expectedNowPlayingMovies, actualResult)
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
}
