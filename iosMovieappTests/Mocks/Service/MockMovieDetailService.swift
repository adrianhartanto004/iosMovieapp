import Foundation
import Combine

@testable import iosMovieapp

class MockMovieDetailService: MovieDetailService {    
    var whenFetchMovieDetail: AnyPublisher <MovieDetail, Error>!
    var whenFetchMovieCredits: AnyPublisher <MovieCreditList, Error>!
    var whenFetchMoviePhotos: AnyPublisher <MoviePhotoList, Error>!
    var whenFetchAuthorReviews: AnyPublisher <AuthorReviewList, Error>!
    
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        return whenFetchMovieDetail
    }
    
    func fetchMovieCredits(movieId: Int) -> AnyPublisher<MovieCreditList, Error> {
        return whenFetchMovieCredits
    }
    
    func fetchMoviePhotos(movieId: Int) -> AnyPublisher<MoviePhotoList, Error> {
        return whenFetchMoviePhotos
    }
    
    func fetchAuthorReviews(movieId: Int) -> AnyPublisher<AuthorReviewList, Error> {
        return whenFetchAuthorReviews
    }
}
