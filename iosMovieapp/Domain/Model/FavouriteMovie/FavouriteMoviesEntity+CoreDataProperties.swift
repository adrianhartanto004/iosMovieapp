import Foundation
import CoreData


extension FavouriteMoviesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteMoviesEntity> {
        return NSFetchRequest<FavouriteMoviesEntity>(entityName: "FavouriteMoviesEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32
    @NSManaged public var addedAt: Date
    @NSManaged public var releaseDate: String?

}

extension FavouriteMoviesEntity : Identifiable {

}

extension FavouriteMoviesEntity: ManagedEntity {}
