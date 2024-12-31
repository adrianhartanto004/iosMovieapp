import Foundation
import Combine

protocol FetchMovieDetailUsecase {
    func execute(movieId: Int) -> AnyPublisher<Void, Error>
}

class FetchMovieDetailUsecaseImpl: FetchMovieDetailUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieRepository.fetchMovieDetail(movieId: movieId)
    }
}
