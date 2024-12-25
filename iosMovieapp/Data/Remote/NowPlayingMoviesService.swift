import Foundation
import Combine

protocol NowPlayingMoviesService {
    func fetch() -> AnyPublisher<NowPlayingMoviesList, Error>
}

class NowPlayingMoviesServiceImpl: NetworkClientManager<HttpRequest>, NowPlayingMoviesService {
    func fetch() -> AnyPublisher<NowPlayingMoviesList, Error> {
        self.request(
            request: HttpRequest(request: NowPlayingMoviesRequest()),
            scheduler: DispatchQueue.main,
            responseObject: NowPlayingMoviesList.self
        )
    }
}

struct NowPlayingMoviesRequest: NetworkTarget {    
    var path: String? {
        return Constants.EndpointUrls.fetchNowPlayingMovies
    }
    
    var methodType: HTTPMethod {
        .get
    }
    
    var queryParams: [String : String]? {
        [
            "api_key": Constants.Key.API_KEY,
            "page": "1"
        ]
    }
    
    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
