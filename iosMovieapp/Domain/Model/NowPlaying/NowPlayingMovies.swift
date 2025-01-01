import Foundation
import CoreData

struct NowPlayingMovies: Codable, Equatable {    
    let id: Int
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
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
        id = try values.decode(Int.self, forKey: .id)
        posterPath = try values.decode(String.self, forKey: .posterPath)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        title = try values.decode(String.self, forKey: .title)
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
        voteCount = try values.decode(Int.self, forKey: .voteCount)
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext, index: Int16) -> NowPlayingMoviesEntity? {
        guard let nowPlayingMoviesEntity = NowPlayingMoviesEntity.insertNew(in: context)
        else { return nil }
        nowPlayingMoviesEntity.id = Int32(id)
        nowPlayingMoviesEntity.index = Int32(index)
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
            id: Int(self.id),
            posterPath: self.posterPath ?? "",
            releaseDate: self.releaseDate ?? "",
            title: self.title ?? "",
            voteAverage: self.voteAverage, 
            voteCount: Int(self.voteCount)
        )
    }
}
