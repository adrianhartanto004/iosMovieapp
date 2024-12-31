import Foundation
import CoreData


extension NowPlayingMoviesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NowPlayingMoviesEntity> {
        return NSFetchRequest<NowPlayingMoviesEntity>(entityName: "NowPlayingMoviesEntity")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var id: Int32
    @NSManaged public var index: Int32
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32

}

extension NowPlayingMoviesEntity : Identifiable {

}
