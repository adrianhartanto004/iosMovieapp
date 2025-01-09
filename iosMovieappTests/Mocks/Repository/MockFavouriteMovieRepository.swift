import Foundation
import Combine

@testable import iosMovieapp

class MockFavouriteMovieRepository: FavouriteMovieRepository {    
    var whenAddFavouriteMovie: AnyPublisher <Void, Error>!
    var whenFetchAllFavouriteMovies: AnyPublisher <[NowPlayingMovies], Error>!
    var whenDoesFavouriteMovieExist: AnyPublisher <Bool, Error>!
    
    func addFavouriteMovie(movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
        return whenAddFavouriteMovie
    }
    
    func fetchAllFavouriteMovies() -> AnyPublisher<[NowPlayingMovies], Error> {
        return whenFetchAllFavouriteMovies
    }
    
    func doesFavouriteMovieExist(movieId: Int) -> AnyPublisher<Bool, Error> {
        return whenDoesFavouriteMovieExist
    }
}
