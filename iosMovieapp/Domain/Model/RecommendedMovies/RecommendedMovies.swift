import Foundation
import CoreData

struct RecommendedMovies: Codable, Equatable {    
    let adult: Bool
    let backdropPath: String
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension RecommendedMovies {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decode(Bool.self, forKey: .adult)
        backdropPath = try values.decode(String.self, forKey: .backdropPath)
        genreIds = try values.decode([Int].self, forKey: .genreIds)
        id = try values.decode(Int.self, forKey: .id)
        originalLanguage = try values.decode(String.self, forKey: .originalLanguage)
        originalTitle = try values.decode(String.self, forKey: .originalTitle)
        overview = try values.decode(String.self, forKey: .overview)
        popularity = try values.decode(Double.self, forKey: .popularity)
        posterPath = try values.decode(String.self, forKey: .posterPath)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        title = try values.decode(String.self, forKey: .title)
        video = try values.decode(Bool.self, forKey: .video)
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
        voteCount = try values.decode(Int.self, forKey: .voteCount)
    }
}
