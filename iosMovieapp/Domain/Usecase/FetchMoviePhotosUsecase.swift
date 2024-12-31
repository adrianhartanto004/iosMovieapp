import Foundation
import Combine

protocol FetchMoviePhotosUsecase {
    func execute(movieId: Int) -> AnyPublisher<Void, Error>
}

class FetchMoviePhotosUsecaseImpl: FetchMoviePhotosUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieRepository.fetchMoviePhotos(movieId: movieId)
    }
}
