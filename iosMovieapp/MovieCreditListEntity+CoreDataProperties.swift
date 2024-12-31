import Foundation
import CoreData


extension MovieCreditListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCreditListEntity> {
        return NSFetchRequest<MovieCreditListEntity>(entityName: "MovieCreditListEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var casts: NSSet?

}

// MARK: Generated accessors for casts
extension MovieCreditListEntity {

    @objc(addCastsObject:)
    @NSManaged public func addToCasts(_ value: MovieCastsEntity)

    @objc(removeCastsObject:)
    @NSManaged public func removeFromCasts(_ value: MovieCastsEntity)

    @objc(addCasts:)
    @NSManaged public func addToCasts(_ values: NSSet)

    @objc(removeCasts:)
    @NSManaged public func removeFromCasts(_ values: NSSet)

}

extension MovieCreditListEntity : Identifiable {

}
