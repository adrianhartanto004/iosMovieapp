import XCTest
import Combine
@testable import iosMovieapp

class FavouriteMoviesViewModelTest: XCTestCase {
    private var mockGetFavouriteMoviesUsecase: MockGetFavouriteMoviesUsecase!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: FavouriteMoviesViewModel!
    
    override func setUp() {
        mockGetFavouriteMoviesUsecase = MockGetFavouriteMoviesUsecase()
        sut = FavouriteMoviesViewModel(mockGetFavouriteMoviesUsecase)
    }
    
    override func tearDown() {
        sut = nil
        mockGetFavouriteMoviesUsecase = nil
    }
    
    func test_loadFavouriteMovies_shouldReturnData() throws {
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100))
        ]
        let loadingExp = XCTestExpectation(description: #function)
        let nowPlayingMoviesExp = XCTestExpectation(description: #function)
        var actualResult: [NowPlayingMovies] = []
        
        mockGetFavouriteMoviesUsecase.whenExecute = Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut.loadFavouriteMovies()
        XCTAssertTrue(sut.isLoading)
        XCTAssertNil(sut.favouriteMoviesError)
        
        sut.$isLoading
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
                XCTAssertNil(self.sut.favouriteMoviesError)
                nowPlayingMoviesExp.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [loadingExp, nowPlayingMoviesExp], timeout: 5)
        
        XCTAssertEqual(expectedNowPlayingMovies, actualResult)
    }
    
    func test_loadFavouriteMoviesError_shouldReturnError() throws {
        let errorExp = XCTestExpectation(description: #function)
        let loadingExp = XCTestExpectation(description: #function)
        let error = NSError.test
        
        mockGetFavouriteMoviesUsecase.whenExecute = Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut.loadFavouriteMovies()
        XCTAssertTrue(sut.isLoading)
        XCTAssertNil(sut.favouriteMoviesError)
        
        sut.$favouriteMoviesError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                errorExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                loadingExp.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [errorExp, loadingExp], timeout: 5)
        
        XCTAssertNotNil(sut.favouriteMoviesError)
    }
}
