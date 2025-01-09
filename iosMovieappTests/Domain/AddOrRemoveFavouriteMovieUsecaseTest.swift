import XCTest
import Combine
@testable import iosMovieapp

class AddOrRemoveFavouriteMovieUsecaseTest: XCTestCase {
    private var mockFavouriteMovieRepository: MockFavouriteMovieRepository!
    private var sut: AddOrRemoveFavouriteMovieUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockFavouriteMovieRepository = MockFavouriteMovieRepository()
        sut = AddOrRemoveFavouriteMovieUsecaseImpl(favouriteMovieRepository: mockFavouriteMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockFavouriteMovieRepository = nil
    }
    
    func test_execute_shouldReturnCompleted() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        
        mockFavouriteMovieRepository.whenAddFavouriteMovie = 
            Result.success(()).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieDetail: expectedMovieDetail)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                },
                receiveValue: { _ in
                    isExecuteCompleted = true
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(isExecuteCompleted)
    }
    
    func test_execute_error() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = createMovieDetail(movieId: movieId)
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockFavouriteMovieRepository.whenAddFavouriteMovie = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieDetail: expectedMovieDetail)
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
