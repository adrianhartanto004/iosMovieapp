import Foundation

struct MovieCreditsRequest: NetworkTarget {
    let movieId: Int
    
    var path: String? {
        return "\(Constants.EndpointUrls.movieDetail)\(movieId)\(Constants.EndpointUrls.fetchMovieCredits)"
    }
    
    var methodType: HTTPMethod {
        .get
    }
    
    var queryParams: [String : String]? {
        [
            "api_key": Constants.Key.API_KEY
        ]
    }
    
    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
