import Foundation

struct NowPlayingMoviesList: Codable, Equatable {    
    let page: Int
    let nowPlayingMovies: [NowPlayingMovies]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case nowPlayingMovies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension NowPlayingMoviesList {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        nowPlayingMovies = try values.decode([NowPlayingMovies].self, forKey: .nowPlayingMovies)
        totalPages = try values.decode(Int.self, forKey: .totalPages)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
    }
}
