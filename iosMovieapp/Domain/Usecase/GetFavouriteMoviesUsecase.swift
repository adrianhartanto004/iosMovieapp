import Foundation
import Combine

protocol GetFavouriteMoviesUsecase {
    func execute() -> AnyPublisher<[NowPlayingMovies], Error>
}

class GetFavouriteMoviesUsecaseImpl: GetFavouriteMoviesUsecase {
    let favouriteMovieRepository: FavouriteMovieRepository
    
    init(favouriteMovieRepository: FavouriteMovieRepository) {
        self.favouriteMovieRepository = favouriteMovieRepository
    }
    
    func execute() -> AnyPublisher<[NowPlayingMovies], Error> {
        return favouriteMovieRepository.fetchAllFavouriteMovies()
    }
}
