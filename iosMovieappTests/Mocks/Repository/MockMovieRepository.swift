import Foundation
import Combine

@testable import iosMovieapp

class MockMovieRepository: MovieRepository {
        var whenFetchNowPlayingMovies: AnyPublisher <Void, Error>!
        var whenLoadMoreNowPlayingMovies: AnyPublisher <Void, Error>!
        var whenGetNowPlayingMovies: AnyPublisher <[NowPlayingMovies], Error>!
        var whenFetchMovieDetail: AnyPublisher <Void, Error>!
        var whenGetMovieDetail: AnyPublisher <MovieDetail, Error>!
        var whenFetchMovieCredits: AnyPublisher <Void, Error>!
        var whenGetMovieCasts: AnyPublisher <[Cast], Error>!
        var whenFetchMoviePhotos: AnyPublisher <Void, Error>!
        var whenGetMoviePhotos: AnyPublisher <[Photo], Error>!
        var whenFetchAuthorReviews: AnyPublisher <Void, Error>!
        var whenGetAuthorReviews: AnyPublisher <[AuthorReview], Error>!
    
    func fetchNowPlayingMovies() -> AnyPublisher<Void, Error> {
        return whenFetchNowPlayingMovies
    }
    
    func loadMoreNowPlayingMovies(page: Int) -> AnyPublisher<Void, Error> {
        return whenLoadMoreNowPlayingMovies
    }
    
    func getNowPlayingMovies(limit: Int?) -> AnyPublisher<[NowPlayingMovies], Error> {
        return whenGetNowPlayingMovies
    }
    
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenFetchMovieDetail
    }
    
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        return whenGetMovieDetail
    }
    
    func fetchMovieCredits(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenFetchMovieCredits
    }
    
    func getMovieCasts(movieId: Int) -> AnyPublisher<[Cast], Error> {
        return whenGetMovieCasts
    }
    
    func fetchMoviePhotos(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenFetchMoviePhotos
    }
    
    func getMoviePhotos(movieId: Int) -> AnyPublisher<[Photo], Error> {
        return whenGetMoviePhotos
    }
    
    func fetchAuthorReviews(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenFetchAuthorReviews
    }
    
    func getAuthorReviews(movieId: Int) -> AnyPublisher<[AuthorReview], Error> {
        return whenGetAuthorReviews
    }
}
