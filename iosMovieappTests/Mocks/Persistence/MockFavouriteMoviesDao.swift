import Foundation
import Combine
import CoreData

@testable import iosMovieapp

class MockFavouriteMoviesDao: FavouriteMoviesDao {    
    var whenInsert: AnyPublisher <Void, Error>!
    var whenFetchAllFavouriteMovies: AnyPublisher <[NowPlayingMovies], Error>!
    var whenDoesFavouriteMovieExist: AnyPublisher <Bool, Error>!
    var whenDeleteFavouriteMovie: AnyPublisher <Void, Error>!
    
    func insert(movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
        return whenInsert
    }
    
    func fetchAllFavouriteMovies() -> AnyPublisher<[NowPlayingMovies], Error> {
        return whenFetchAllFavouriteMovies
    }
    
    func doesFavouriteMovieExist(movieId: Int) -> AnyPublisher<Bool, Error> {
        return whenDoesFavouriteMovieExist
    }
    
    func deleteFavouriteMovie(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenDeleteFavouriteMovie
    }
}
