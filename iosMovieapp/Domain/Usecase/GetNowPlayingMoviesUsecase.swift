import Foundation
import Combine

protocol GetNowPlayingMoviesUsecase {
    func execute(limit: Int?) -> AnyPublisher<[NowPlayingMovies], Error>
}

class GetNowPlayingMoviesUsecaseImpl: GetNowPlayingMoviesUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(limit: Int?) -> AnyPublisher<[NowPlayingMovies], Error> {
        return movieRepository.getNowPlayingMovies(limit: limit)
    }
}
