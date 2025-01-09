import Foundation
import Combine

@testable import iosMovieapp

class MockGetMoviePhotosUsecase: GetMoviePhotosUsecase {    
    var whenExecute: AnyPublisher <[Photo], Error>!
    
    func execute(movieId: Int) -> AnyPublisher<[Photo], Error> {
        return whenExecute
    }
}
