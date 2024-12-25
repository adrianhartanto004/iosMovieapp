import Foundation
import CoreData

struct NowPlayingMovies: Codable, Equatable {    
    let adult: Bool
    let backdropPath: String
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension NowPlayingMovies {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decode(Bool.self, forKey: .adult)
        backdropPath = try values.decode(String.self, forKey: .backdropPath)
        id = try values.decode(Int.self, forKey: .id)
        originalLanguage = try values.decode(String.self, forKey: .originalLanguage)
        originalTitle = try values.decode(String.self, forKey: .originalTitle)
        overview = try values.decode(String.self, forKey: .overview)
        popularity = try values.decode(Double.self, forKey: .popularity)
        posterPath = try values.decode(String.self, forKey: .posterPath)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        title = try values.decode(String.self, forKey: .title)
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
        voteCount = try values.decode(Int.self, forKey: .voteCount)
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext, id: Int16) -> NowPlayingMoviesEntity? {
        guard let nowPlayingMoviesEntity = NowPlayingMoviesEntity.insertNew(in: context)
        else { return nil }
        nowPlayingMoviesEntity.adult = adult
        nowPlayingMoviesEntity.backdropPath = backdropPath
        nowPlayingMoviesEntity.id = Int32(id)
        nowPlayingMoviesEntity.originalLanguage = originalLanguage
        nowPlayingMoviesEntity.originalTitle = originalTitle
        nowPlayingMoviesEntity.overview = overview
        nowPlayingMoviesEntity.popularity = popularity
        nowPlayingMoviesEntity.posterPath = posterPath
        nowPlayingMoviesEntity.releaseDate = releaseDate
        nowPlayingMoviesEntity.title = title
        nowPlayingMoviesEntity.voteAverage = voteAverage
        nowPlayingMoviesEntity.voteCount = Int32(voteCount)
        
        return nowPlayingMoviesEntity
    }
}

extension NowPlayingMoviesEntity: ManagedEntity {
    func toNowPlayingMovies() -> NowPlayingMovies {
        return NowPlayingMovies(
            adult: self.adult,
            backdropPath: self.backdropPath ?? "",
            id: Int(self.id),
            originalLanguage: self.originalLanguage ?? "",
            originalTitle: self.originalTitle ?? "",
            overview: self.overview ?? "",
            popularity: self.popularity,
            posterPath: self.posterPath ?? "",
            releaseDate: self.releaseDate ?? "",
            title: self.title ?? "",
            voteAverage: self.voteAverage, 
            voteCount: Int(self.voteCount)
        )
    }
}
