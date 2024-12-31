import Foundation
import Combine

protocol FetchRecommendedMoviesUsecase {
    func execute(movieId: Int) -> AnyPublisher<RecommendedMoviesList, Error>
}

class FetchRecommendedMoviesUsecaseImpl: FetchRecommendedMoviesUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<RecommendedMoviesList, Error> {
        return movieRepository.fetchRecommendedMovies(movieId: movieId)
    }
}
