import Foundation
import Combine

protocol FetchNowPlayingMoviesUsecase {
    func execute() -> AnyPublisher<Void, Error>
}

class FetchNowPlayingMoviesUsecaseImpl: FetchNowPlayingMoviesUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute() -> AnyPublisher<Void, Error> {
        return movieRepository.fetchNowPlayingMovies()
    }
}
