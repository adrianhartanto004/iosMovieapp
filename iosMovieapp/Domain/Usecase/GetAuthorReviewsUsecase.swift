import Foundation
import Combine

protocol GetAuthorReviewsUsecase {
    func execute(movieId: Int) -> AnyPublisher<[AuthorReview], Error>
}

class GetAuthorReviewsUsecaseImpl: GetAuthorReviewsUsecase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieId: Int) -> AnyPublisher<[AuthorReview], Error> {
        return movieRepository.getAuthorReviews(movieId: movieId)
    }
}
