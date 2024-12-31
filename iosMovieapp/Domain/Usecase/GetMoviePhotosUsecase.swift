import Foundation
import Combine

protocol GetMoviePhotosUsecase {
    func execute(movieId: Int) -> AnyPublisher<[Photo], Error>
}

class GetMoviePhotosUsecaseImpl: GetMoviePhotosUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<[Photo], Error> {
        return movieRepository.getMoviePhotos(movieId: movieId)
    }
}
