import Foundation
import Combine

protocol FavouriteMovieRepository {
    func addFavouriteMovie(movieDetail: MovieDetail) -> AnyPublisher<Void, Error>
    func fetchAllFavouriteMovies() -> AnyPublisher<[NowPlayingMovies], Error>
    func doesFavouriteMovieExist(movieId: Int) -> AnyPublisher<Bool, Error>
}

class FavouriteMovieRepositoryImpl: FavouriteMovieRepository {
    let favouriteMoviesDao: FavouriteMoviesDao
    
    init(
        favouriteMoviesDao: FavouriteMoviesDao
    ) {
        self.favouriteMoviesDao = favouriteMoviesDao
    }
    
    func addFavouriteMovie(movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
        return favouriteMoviesDao
            .doesFavouriteMovieExist(movieId: movieDetail.id)
            .flatMap { [weak self] isExist -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "FavouriteMovieRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                if isExist {
                    return self.favouriteMoviesDao.deleteFavouriteMovie(movieId: movieDetail.id)
                } else {
                    return self.favouriteMoviesDao.insert(movieDetail: movieDetail)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchAllFavouriteMovies() -> AnyPublisher<[NowPlayingMovies], Error> {
        return favouriteMoviesDao.fetchAllFavouriteMovies()
    }
    
    func doesFavouriteMovieExist(movieId: Int) -> AnyPublisher<Bool, Error> {
        return self.favouriteMoviesDao.doesFavouriteMovieExist(movieId: movieId)
    }
}
