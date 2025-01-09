import Foundation
import Combine

@testable import iosMovieapp

class MockLoadMoreNowPlayingMoviesUsecase: LoadMoreNowPlayingMoviesUsecase {
    var whenExecute: AnyPublisher <Void, Error>!
    
    func execute(page: Int) -> AnyPublisher<Void,  Error> {
        return whenExecute
    }
}
