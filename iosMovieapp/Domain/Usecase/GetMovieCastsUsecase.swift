import Foundation
import Combine

protocol GetMovieCastsUsecase {
    func execute(movieId: Int) -> AnyPublisher<[Cast], Error>
}

class GetMovieCastsUsecaseImpl: GetMovieCastsUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<[Cast], Error> {
        return movieRepository.getMovieCasts(movieId: movieId)
    }
}
