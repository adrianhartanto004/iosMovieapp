import Foundation
import Combine

@testable import iosMovieapp

class MockNowPlayingMoviesService: NowPlayingMoviesService {
    var whenFetchedResult: AnyPublisher <NowPlayingMoviesList, Error>!
    
    func fetch(page: Int) -> AnyPublisher<NowPlayingMoviesList, Error> {
        return whenFetchedResult
    }
}
