import XCTest
import Combine
@testable import iosMovieapp

class GetMovieCastsUsecaseTest: XCTestCase {
    private var mockMovieRepository: MockMovieRepository!
    private var sut: GetMovieCastsUsecase!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        mockMovieRepository = MockMovieRepository()
        sut = GetMovieCastsUsecaseImpl(movieRepository: mockMovieRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieRepository = nil
    }
    
    func test_execute_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        let expectedCasts = [createCast(), createCast(), createCast()]
        var actualResult: [Cast] = []
        
        mockMovieRepository.whenGetMovieCasts = 
            Result.success(expectedCasts).publisher.eraseToAnyPublisher()
        
        sut
            .execute(movieId: movieId)
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
        
        XCTAssertEqual(expectedCasts, actualResult)
    }
    
    func test_execute_error() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        var isExecuteCompleted: Bool = false
        let error = CoreDataError.contextNotAvailable
        
        mockMovieRepository.whenGetMovieCasts =
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
