import Foundation
import Combine

@testable import iosMovieapp

class MockFetchMovieCreditsUsecase: FetchMovieCreditsUsecase {    
    var whenExecute: AnyPublisher <Void, Error>!
    
    func execute(movieId: Int) -> AnyPublisher<Void, Error> {
        return whenExecute
    }
}
