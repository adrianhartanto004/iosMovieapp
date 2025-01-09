import Foundation
import Combine

@testable import iosMovieapp

class MockFetchNowPlayingMoviesUsecase: FetchNowPlayingMoviesUsecase {
    var whenExecute: AnyPublisher <Void, Error>!
    
    func execute() -> AnyPublisher<Void, Error> {
        return whenExecute
    }
}
