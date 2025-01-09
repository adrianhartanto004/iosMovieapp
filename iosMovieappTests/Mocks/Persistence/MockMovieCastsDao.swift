import Foundation
import Combine
import CoreData

@testable import iosMovieapp

class MockMovieCastsDao: MovieCastsDao {    
    var whenInsertAll: AnyPublisher <Void, Error>!
    var whenFetch: AnyPublisher <[Cast], Error>!
    var whenDeleteMovieCredits: AnyPublisher <Void, Error>!
    
    func insertAll(movieId: Int, _ items: [Cast]) -> AnyPublisher<Void, Error> {
        return whenInsertAll
    }
    
    func fetch(movieId: Int) -> AnyPublisher<[Cast], Error> {
        return whenFetch
    }
    
    func deleteMovieCredit(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenDeleteMovieCredits
    }
}
