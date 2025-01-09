import Foundation
import Combine
import CoreData

@testable import iosMovieapp

class MockMovieDetailDao: MovieDetailDao {   
    var whenInsert: AnyPublisher <Void, Error>!
    var whenFetch: AnyPublisher <MovieDetail, Error>!
    var whenDeleteMovieDetail: AnyPublisher <Void, Error>!
    
    func insert(_ item: iosMovieapp.MovieDetail) -> AnyPublisher<Void, Error> {
        return whenInsert
    }
    
    func fetch(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        return whenFetch
    }
    
    func deleteMovieDetail(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenDeleteMovieDetail
    }
}
