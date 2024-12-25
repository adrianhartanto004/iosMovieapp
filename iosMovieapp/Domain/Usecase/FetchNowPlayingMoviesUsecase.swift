import Foundation
import Combine

protocol FetchNowPlayingMoviesUsecase {
    func execute() -> AnyPublisher<Void, Error>
}

class FetchNowPlayingMoviesUsecaseImpl: FetchNowPlayingMoviesUsecase {
    let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute() -> AnyPublisher<Void, Error> {
        return moviesRepository.fetchNowPlayingMovies()
    }
}
