import Foundation
import Combine

protocol GetIsFavouriteMovieUsecase {
    func execute(movieId: Int) -> AnyPublisher<Bool, Error>
}

class GetIsFavouriteMovieUsecaseImpl: GetIsFavouriteMovieUsecase {
    let favouriteMovieRepository: FavouriteMovieRepository
    
    init(favouriteMovieRepository: FavouriteMovieRepository) {
        self.favouriteMovieRepository = favouriteMovieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<Bool, Error> {
        return favouriteMovieRepository.doesFavouriteMovieExist(movieId: movieId)
    }
}
