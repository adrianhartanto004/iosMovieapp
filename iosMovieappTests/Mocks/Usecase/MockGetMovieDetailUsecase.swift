import Foundation
import Combine

@testable import iosMovieapp

class MockGetMovieDetailUsecase: GetMovieDetailUsecase {    
    var whenExecute: AnyPublisher <MovieDetail, Error>!
    
    func execute(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        return whenExecute
    }
}
