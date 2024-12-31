import Foundation
import CoreData


extension MovieAuthorReviewListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieAuthorReviewListEntity> {
        return NSFetchRequest<MovieAuthorReviewListEntity>(entityName: "MovieAuthorReviewListEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var authorReviews: NSSet?

}

// MARK: Generated accessors for authorReviews
extension MovieAuthorReviewListEntity {

    @objc(addAuthorReviewsObject:)
    @NSManaged public func addToAuthorReviews(_ value: MovieAuthorReviewsEntity)

    @objc(removeAuthorReviewsObject:)
    @NSManaged public func removeFromAuthorReviews(_ value: MovieAuthorReviewsEntity)

    @objc(addAuthorReviews:)
    @NSManaged public func addToAuthorReviews(_ values: NSSet)

    @objc(removeAuthorReviews:)
    @NSManaged public func removeFromAuthorReviews(_ values: NSSet)

}

extension MovieAuthorReviewListEntity : Identifiable {

}
