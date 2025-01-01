import Foundation
import Combine

protocol AddOrRemoveFavouriteMovieUsecase {
    func execute(movieDetail: MovieDetail) -> AnyPublisher<Void, Error>
}

class AddOrRemoveFavouriteMovieUsecaseImpl: AddOrRemoveFavouriteMovieUsecase {
    let favouriteMovieRepository: FavouriteMovieRepository
    
    init(favouriteMovieRepository: FavouriteMovieRepository) {
        self.favouriteMovieRepository = favouriteMovieRepository
    }
    
    func execute(movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
        return favouriteMovieRepository.addFavouriteMovie(movieDetail: movieDetail)
    }
}
