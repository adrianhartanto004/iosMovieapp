import XCTest
import Combine
@testable import iosMovieapp

class MovieDetailServiceTest: XCTestCase, TestHelper {
    private var mockNetworkClient: MockNetworkClient!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: MovieDetailService!
    
    override func setUp() {
        mockNetworkClient = MockNetworkClient()
        sut = MovieDetailServiceImpl(clientURLSession: mockNetworkClient)
    }
    
    override func tearDown() {
        sut = nil
        RequestMocking.removeAllMocks()
    }
    
    func test_fetchMovieDetail_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieDetail = decodeJSONFile(
            filename: "MovieDetailResponse", type: MovieDetail.self
        )
        let exp = XCTestExpectation(description: #function)
        var actualResult: MovieDetail?
        
        try mockNetworkClient.mock(
            request: HttpRequest(request: MovieDetailRequest(movieId: movieId)),
            fileName: "MovieDetailResponse",
            type: MovieDetail.self
        )
        
        sut
            .fetchMovieDetail(movieId: movieId)
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
        XCTAssertEqual(expectedMovieDetail.id, actualResult?.id)
    }
    
    func test_fetchMovieDetail_networkError() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        let expectedError = APIError.noNetwork
        
        try mockNetworkClient.mockError(
            request: HttpRequest(request: MovieDetailRequest(movieId: movieId)),
            error: expectedError,
            httpCode: -1009
        )
        
        sut
            .fetchMovieDetail(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertEqual(
                            expectedError.localizedDescription,
                            error.localizedDescription
                        )
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetchMovieCreditList_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMovieCreditList = decodeJSONFile(
            filename: "MovieCredistListResponse", type: MovieCreditList.self
        )
        let exp = XCTestExpectation(description: #function)
        var actualResult: MovieCreditList?
        
        try mockNetworkClient.mock(
            request: HttpRequest(request: MovieCreditsRequest(movieId: movieId)),
            fileName: "MovieCredistListResponse",
            type: MovieCreditList.self
        )
        
        sut
            .fetchMovieCredits(movieId: movieId)
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
        
        XCTAssertEqual(expectedMovieCreditList, actualResult)
        XCTAssertEqual(expectedMovieCreditList.cast, actualResult?.cast)
    }
    
    func test_fetchMovieCreditList_networkError() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        let expectedError = APIError.noNetwork
        
        try mockNetworkClient.mockError(
            request: HttpRequest(request: MovieCreditsRequest(movieId: movieId)),
            error: expectedError,
            httpCode: -1009
        )
        
        sut
            .fetchMovieCredits(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertEqual(
                            expectedError.localizedDescription,
                            error.localizedDescription
                        )
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetchMoviePhotoList_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedMoviePhotoList = decodeJSONFile(
            filename: "MoviePhotoListResponse", type: MoviePhotoList.self
        )
        let exp = XCTestExpectation(description: #function)
        var actualResult: MoviePhotoList?
        
        try mockNetworkClient.mock(
            request: HttpRequest(request: MoviePhotosRequest(movieId: movieId)),
            fileName: "MoviePhotoListResponse",
            type: MoviePhotoList.self
        )
        
        sut
            .fetchMoviePhotos(movieId: movieId)
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
        
        XCTAssertEqual(expectedMoviePhotoList, actualResult)
        XCTAssertEqual(expectedMoviePhotoList.photos, actualResult?.photos)
    }
    
    func test_fetchMoviePhotoList_networkError() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        let expectedError = APIError.noNetwork
        
        try mockNetworkClient.mockError(
            request: HttpRequest(request: MoviePhotosRequest(movieId: movieId)),
            error: expectedError,
            httpCode: -1009
        )
        
        sut
            .fetchMoviePhotos(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertEqual(
                            expectedError.localizedDescription,
                            error.localizedDescription
                        )
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetchMovieAuthorReviewList_shouldReturnData() throws {
        let movieId = Int.random(in: 1...100)
        let expectedAuthorReviewList = decodeJSONFile(
            filename: "MovieAuthorReviewListResponse", type: AuthorReviewList.self
        )
        let exp = XCTestExpectation(description: #function)
        var actualResult: AuthorReviewList?
        
        try mockNetworkClient.mock(
            request: HttpRequest(request: AuthorReviewsRequest(movieId: movieId)),
            fileName: "MovieAuthorReviewListResponse",
            type: AuthorReviewList.self
        )
        
        sut
            .fetchAuthorReviews(movieId: movieId)
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
        
        XCTAssertEqual(expectedAuthorReviewList, actualResult)
        XCTAssertEqual(expectedAuthorReviewList.authorReviews, actualResult?.authorReviews)
    }
    
    func test_fetchMovieAuthorList_networkError() throws {
        let movieId = Int.random(in: 1...100)
        let exp = XCTestExpectation(description: #function)
        let expectedError = APIError.noNetwork
        
        try mockNetworkClient.mockError(
            request: HttpRequest(request: AuthorReviewsRequest(movieId: movieId)),
            error: expectedError,
            httpCode: -1009
        )
        
        sut
            .fetchAuthorReviews(movieId: movieId)
            .sink(
                receiveCompletion: { completion in
                    exp.fulfill()
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTAssertEqual(
                            expectedError.localizedDescription,
                            error.localizedDescription
                        )
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
}
