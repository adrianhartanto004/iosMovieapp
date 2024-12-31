import Foundation

struct RecommendedMoviesList: Codable, Equatable {    
    let page: Int
    let recommendedMovies: [RecommendedMovies]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case recommendedMovies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension RecommendedMoviesList {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        recommendedMovies = try values.decode([RecommendedMovies].self, forKey: .recommendedMovies)
        totalPages = try values.decode(Int.self, forKey: .totalPages)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
    }
}
