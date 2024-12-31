import Foundation
import Combine

protocol GetMovieDetailUsecase {
    func execute(movieId: Int) -> AnyPublisher<MovieDetail, Error>
}

class GetMovieDetailUsecaseImpl: GetMovieDetailUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        return movieRepository.getMovieDetail(movieId: movieId)
    }
}
