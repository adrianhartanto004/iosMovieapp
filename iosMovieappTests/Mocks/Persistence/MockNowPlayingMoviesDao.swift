import Foundation
import Combine
import CoreData

@testable import iosMovieapp

class MockNowPlayingMoviesDao: NowPlayingMoviesDao {
    var whenInsertAll: AnyPublisher <Void, Error>!
    var whenFetch: AnyPublisher <[NowPlayingMovies], Error>!
    var whenDeleteAll: AnyPublisher <Void, Error>!
    
    func insertAll(_ items: [NowPlayingMovies]) -> AnyPublisher<Void, Error> {
        return whenInsertAll
    }
    
    func fetch(limit: Int? = nil) -> AnyPublisher<[NowPlayingMovies], Error> {
        return whenFetch
    }
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        return whenDeleteAll
    }
}
