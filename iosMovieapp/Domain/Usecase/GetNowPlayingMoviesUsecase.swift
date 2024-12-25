import Foundation
import Combine

protocol GetNowPlayingMoviesUsecase {
    func execute() -> AnyPublisher<[NowPlayingMovies], Error>
}

class GetNowPlayingMoviesUsecaseImpl: GetNowPlayingMoviesUsecase {
    let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute() -> AnyPublisher<[NowPlayingMovies], Error> {
        return moviesRepository.getNowPlayingMovies()
    }
}
