import Foundation
import Combine

protocol LoadMoreNowPlayingMoviesUsecase {
    func execute(page: Int) -> AnyPublisher<Void, Error>
}

class LoadMoreNowPlayingMoviesUsecaseImpl: LoadMoreNowPlayingMoviesUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(page: Int) -> AnyPublisher<Void, Error> {
        return movieRepository.loadMoreNowPlayingMovies(page: page)
    }
}
