import Foundation
import Combine

@testable import iosMovieapp

class MockGetFavouriteMoviesUsecase: GetFavouriteMoviesUsecase {    
    var whenExecute: AnyPublisher <[NowPlayingMovies], Error>!
    
    func execute() -> AnyPublisher<[NowPlayingMovies], Error> {
        return whenExecute
    }
}
