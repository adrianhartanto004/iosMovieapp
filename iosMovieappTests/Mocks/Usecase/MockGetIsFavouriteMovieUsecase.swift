import Foundation
import Combine

@testable import iosMovieapp

class MockGetIsFavouriteMovieUsecase: GetIsFavouriteMovieUsecase {    
    var whenExecute: AnyPublisher <Bool, Error>!
    
    func execute(movieId: Int) -> AnyPublisher<Bool, Error> {
        return whenExecute
    }
}
