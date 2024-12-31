import Foundation
import CoreData


extension MovieAuthorReviewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieAuthorReviewsEntity> {
        return NSFetchRequest<MovieAuthorReviewsEntity>(entityName: "MovieAuthorReviewsEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var id: String?
    @NSManaged public var index: Int32
    @NSManaged public var avatarPath: String?
    @NSManaged public var content: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var rating: Double
    @NSManaged public var authorReviewsRelation: MovieAuthorReviewListEntity?

}

extension MovieAuthorReviewsEntity : Identifiable {

}
