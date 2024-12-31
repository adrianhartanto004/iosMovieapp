import Foundation

struct RecommendedMoviesRequest: NetworkTarget {
    let movieId: Int
    
    var path: String? {
        return "\(Constants.EndpointUrls.movieDetail)\(movieId)\(Constants.EndpointUrls.fetchMovieRecommendedMovies)"
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
