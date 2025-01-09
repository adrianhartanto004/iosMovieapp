import XCTest
import Combine
@testable import iosMovieapp

class GetFavouriteMoviesUsecaseTest: XCTestCase {
    private var mockFavouriteMovieRepository: MockFavouriteMovieRepository!
    private var sut: GetFavouriteMoviesUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockFavouriteMovieRepository = MockFavouriteMovieRepository()
        sut = GetFavouriteMoviesUsecaseImpl(favouriteMovieRepository: mockFavouriteMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockFavouriteMovieRepository = nil
    }
    
    func test_execute_shouldReturnData() throws {
        let exp = XCTestExpectation(description: #function)
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1),
            createNowPlayingMovies(movieId: 2),
            createNowPlayingMovies(movieId: 3)
        ]
        var actualResult: [NowPlayingMovies] = []
        
        mockFavouriteMovieRepository.whenFetchAllFavouriteMovies = 
            Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut
            .execute()
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
    
    func test_execute_error() throws {
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockFavouriteMovieRepository.whenFetchAllFavouriteMovies =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .execute()
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
                    isExecuteCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertFalse(isExecuteCompleted)
    }
}
