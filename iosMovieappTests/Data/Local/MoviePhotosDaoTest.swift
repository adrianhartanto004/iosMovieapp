import XCTest
import Combine
@testable import iosMovieapp

class MoviePhotosDaoTest: XCTestCase {
    private var persistentStore: MockPersistenceStore!
    private var cancellables: Set<AnyCancellable> = []
    
    private var sut: MoviePhotosDao!
    
    override func setUp() {
        persistentStore = MockPersistenceStore()
        sut = MoviePhotosDaoImpl(persistentStore: persistentStore)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_insertAndFetch_shouldReturnData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedPhotos = [
            createPhotos(),
            createPhotos(),
            createPhotos()
        ]
        let exp = XCTestExpectation(description: #function)
        var actualResult: [Photo] = []
        
        sut
            .insertAll(movieId: expectedMovieId, expectedPhotos)
            .flatMap { _ -> AnyPublisher<[Photo], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
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
        
        XCTAssertEqual(expectedPhotos, actualResult)
    }
    
    func test_insertEmptyAndFetch_shouldReturnEmptyData() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedPhoto: [Photo] = []
        let exp = XCTestExpectation(description: #function)
        var actualResult: [Photo] = []
        
        sut
            .insertAll(movieId: expectedMovieId, expectedPhoto)
            .flatMap { _ -> AnyPublisher<[Photo], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
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
        
        XCTAssertEqual(expectedPhoto, actualResult)
    }
    
    func test_insertAndDeleteAll_shouldReturnNotAvailableError() {
        let expectedMovieId = Int.random(in: 1...100)
        let expectedPhotos = [
            createPhotos(),
            createPhotos(),
            createPhotos()
        ]
        let exp = XCTestExpectation(description: #function)
        
        sut
            .insertAll(movieId: expectedMovieId, expectedPhotos)
            .flatMap { _ -> AnyPublisher<[Photo], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
            .flatMap { photos -> AnyPublisher<Void, Error> in
                XCTAssertFalse(photos.isEmpty)
                return self.sut.deleteMoviePhoto(movieId: expectedMovieId)
            }
            .flatMap { _ -> AnyPublisher<[Photo], Error> in
                return self.sut.fetch(movieId: expectedMovieId)
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssertEqual(error as? CoreDataError, .dataNotAvailable)
                        exp.fulfill()
                    case .finished:
                        XCTFail("Expected failure, but completed successfully.")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Expected no value, but got one.")
                }
            )
            .store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
}
