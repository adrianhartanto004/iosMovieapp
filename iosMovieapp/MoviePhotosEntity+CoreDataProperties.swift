import Foundation
import CoreData


extension MoviePhotosEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviePhotosEntity> {
        return NSFetchRequest<MoviePhotosEntity>(entityName: "MoviePhotosEntity")
    }

    @NSManaged public var filePath: String?
    @NSManaged public var index: Int32
    @NSManaged public var photosRelation: MoviePhotoListEntity?

}

extension MoviePhotosEntity : Identifiable {

}
