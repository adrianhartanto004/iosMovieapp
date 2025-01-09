import XCTest
import Combine
@testable import iosMovieapp

class GetIsFavouriteMovieUsecaseTest: XCTestCase {
    private var mockFavouriteMovieRepository: MockFavouriteMovieRepository!
    private var sut: GetIsFavouriteMovieUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockFavouriteMovieRepository = MockFavouriteMovieRepository()
        sut = GetIsFavouriteMovieUsecaseImpl(favouriteMovieRepository: mockFavouriteMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockFavouriteMovieRepository = nil
    }
    
    func test_execute_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        let expectedResult = Bool.random()
        var actualResult = false
        
        mockFavouriteMovieRepository.whenDoesFavouriteMovieExist = 
            Result.success(expectedResult).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: movieId)
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
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func test_execute_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockFavouriteMovieRepository.whenDoesFavouriteMovieExist = 
            Result.failure(error).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: movieId)
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
