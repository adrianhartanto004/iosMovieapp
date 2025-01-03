import Foundation
import Combine

protocol NowPlayingMoviesService {
    func fetch(page: Int) -> AnyPublisher<NowPlayingMoviesList, Error>
}

class NowPlayingMoviesServiceImpl: NetworkClientManager<HttpRequest>, NowPlayingMoviesService {
    func fetch(page: Int) -> AnyPublisher<NowPlayingMoviesList, Error> {
        self.request(
            request: HttpRequest(request: NowPlayingMoviesRequest(page: page)),
            scheduler: DispatchQueue.main,
            responseObject: NowPlayingMoviesList.self
        )
    }
}

struct NowPlayingMoviesRequest: NetworkTarget {
    let page: Int
    var path: String? {
        return Constants.EndpointUrls.fetchNowPlayingMovies
    }
    
    var methodType: HTTPMethod {
        .get
    }
    
    var queryParams: [String : String]? {
        [
            "api_key": Key.API_KEY,
            "page": "\(page)"
        ]
    }
    
    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
