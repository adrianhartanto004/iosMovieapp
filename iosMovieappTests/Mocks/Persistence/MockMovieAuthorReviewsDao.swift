import Foundation
import Combine
import CoreData

@testable import iosMovieapp

class MockMovieAuthorReviewsDao: MovieAuthorReviewsDao {    
    var whenInsertAll: AnyPublisher <Void, Error>!
    var whenFetch: AnyPublisher <[AuthorReview], Error>!
    var whenDeleteMovieAuthorReviews: AnyPublisher <Void, Error>!
    
    func insertAll(movieId: Int, _ items: [AuthorReview]) -> AnyPublisher<Void, Error> {
        return whenInsertAll
    }
    
    func fetch(movieId: Int) -> AnyPublisher<[AuthorReview], Error> {
        return whenFetch
    }
    
    func deleteMovieAuthorReviews(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenDeleteMovieAuthorReviews
    }
}
