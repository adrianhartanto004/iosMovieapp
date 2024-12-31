import Foundation
import Combine

protocol FetchMovieCreditsUsecase {
    func execute(movieId: Int) -> AnyPublisher<Void, Error>
}

class FetchMovieCreditsUsecaseImpl: FetchMovieCreditsUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieRepository.fetchMovieCredits(movieId: movieId)
    }
}
