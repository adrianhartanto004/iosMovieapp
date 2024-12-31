import Foundation
import CoreData


extension MovieDetailGenresEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetailGenresEntity> {
        return NSFetchRequest<MovieDetailGenresEntity>(entityName: "MovieDetailGenresEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var genresRelation: MovieDetailEntity?

}

extension MovieDetailGenresEntity : Identifiable {

}
