import Foundation
import Combine
import CoreData

@testable import iosMovieapp

class MockMoviePhotosDao: MoviePhotosDao {    
    var whenInsertAll: AnyPublisher <Void, Error>!
    var whenFetch: AnyPublisher <[Photo], Error>!
    var whenDeleteMoviePhoto: AnyPublisher <Void, Error>!
    
    func insertAll(movieId: Int, _ items: [Photo]) -> AnyPublisher<Void, Error> {
        return whenInsertAll
    }
    
    func fetch(movieId: Int) -> AnyPublisher<[Photo], Error> {
        return whenFetch
    }
    
    func deleteMoviePhoto(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenDeleteMoviePhoto
    }
}
