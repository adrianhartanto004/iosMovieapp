import Foundation
import Combine

@testable import iosMovieapp

class MockGetAuthorReviewsUsecase: GetAuthorReviewsUsecase {    
    var whenExecute: AnyPublisher <[AuthorReview], Error>!
    
    func execute(movieId: Int) -> AnyPublisher<[AuthorReview], Error> {
        return whenExecute
    }
}
