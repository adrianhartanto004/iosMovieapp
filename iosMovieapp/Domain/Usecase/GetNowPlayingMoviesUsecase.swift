import Foundation
import Combine

protocol GetNowPlayingMoviesUsecase {
    func execute() -> AnyPublisher<[NowPlayingMovies], Error>
}

class GetNowPlayingMoviesUsecaseImpl: GetNowPlayingMoviesUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute() -> AnyPublisher<[NowPlayingMovies], Error> {
        return movieRepository.getNowPlayingMovies()
    }
}
