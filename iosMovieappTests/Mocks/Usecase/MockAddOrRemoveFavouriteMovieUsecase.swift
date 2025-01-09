import Foundation
import Combine

@testable import iosMovieapp

class MockAddOrRemoveFavouriteMovieUsecase: AddOrRemoveFavouriteMovieUsecase {    
    var whenExecute: AnyPublisher <Void, Error>!
    
    func execute(movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
        return whenExecute
    }
}
