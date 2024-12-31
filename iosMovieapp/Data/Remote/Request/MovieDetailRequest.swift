import Foundation

struct MovieDetailRequest: NetworkTarget {
    let movieId: Int
    
    var path: String? {
        return "\(Constants.EndpointUrls.movieDetail)\(movieId)"
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
