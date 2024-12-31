import Foundation
import Combine

protocol FetchAuthorReviewsUsecase {
    func execute(movieId: Int) -> AnyPublisher<Void, Error>
}

class FetchAuthorReviewsUsecaseImpl: FetchAuthorReviewsUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieRepository.fetchAuthorReviews(movieId: movieId)
    }
}
