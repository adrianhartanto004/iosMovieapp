import Foundation
import Combine

@testable import iosMovieapp

class MockGetMovieCastsUsecase: GetMovieCastsUsecase {    
    var whenExecute: AnyPublisher <[Cast], Error>!
    
    func execute(movieId: Int) -> AnyPublisher<[Cast], Error> {
        return whenExecute
    }
}
