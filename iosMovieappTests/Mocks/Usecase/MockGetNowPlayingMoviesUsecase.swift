import Foundation
import Combine

@testable import iosMovieapp

class MockGetNowPlayingMoviesUsecase: GetNowPlayingMoviesUsecase {    
    var whenExecute: AnyPublisher <[NowPlayingMovies], Error>!
    
    func execute(limit: Int?) -> AnyPublisher<[NowPlayingMovies], Error> {
        return whenExecute
    }
}
