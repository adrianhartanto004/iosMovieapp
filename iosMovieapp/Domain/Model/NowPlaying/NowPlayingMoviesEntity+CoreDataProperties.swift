import Foundation
import CoreData


extension NowPlayingMoviesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NowPlayingMoviesEntity> {
        return NSFetchRequest<NowPlayingMoviesEntity>(entityName: "NowPlayingMoviesEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var index: Int32
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32

}

extension NowPlayingMoviesEntity : Identifiable {

}
