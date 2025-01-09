import XCTest
import Combine
@testable import iosMovieapp

class GetNowPlayingMoviesUsecaseTest: XCTestCase {
    private var mockMovieRepository: MockMovieRepository!
    private var sut: GetNowPlayingMoviesUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockMovieRepository = MockMovieRepository()
        sut = GetNowPlayingMoviesUsecaseImpl(movieRepository: mockMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieRepository = nil
    }
    
    func test_execute_shouldReturnData() throws {
        let exp = XCTestExpectation(description: #function)
        let expectedNowPlayingMovies = [
            createNowPlayingMovies(movieId: 1),
            createNowPlayingMovies(movieId: 2),
            createNowPlayingMovies(movieId: 3)
        ]
        var actualResult: [NowPlayingMovies] = []
        
        mockMovieRepository.whenGetNowPlayingMovies = 
            Result.success(expectedNowPlayingMovies).publisher.eraseToAnyPublisher()
        
        sut
            .execute(limit: nil)
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
        
        mockMovieRepository.whenGetNowPlayingMovies =
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .execute(limit: nil)
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
