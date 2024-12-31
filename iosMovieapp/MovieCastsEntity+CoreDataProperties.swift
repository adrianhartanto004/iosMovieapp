import Foundation
import CoreData


extension MovieCastsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCastsEntity> {
        return NSFetchRequest<MovieCastsEntity>(entityName: "MovieCastsEntity")
    }

    @NSManaged public var profilePath: String?
    @NSManaged public var index: Int32
    @NSManaged public var castId: Int32
    @NSManaged public var name: String?
    @NSManaged public var castsRelation: MovieCreditListEntity?

}

extension MovieCastsEntity : Identifiable {

}
