import Foundation

struct AuthorReviewsRequest: NetworkTarget {
    let movieId: Int
    
    var path: String? {
        return "\(Constants.EndpointUrls.movieDetail)\(movieId)\(Constants.EndpointUrls.fetchMovieAuthorReviews)"
    }
    
    var methodType: HTTPMethod {
        .get
    }
    
    var queryParams: [String : String]? {
        [
            "api_key": Key.API_KEY,
            "page": "1"
        ]
    }
    
    var queryParamsEncoding: URLEncoding? {
        return .default
    }
}
