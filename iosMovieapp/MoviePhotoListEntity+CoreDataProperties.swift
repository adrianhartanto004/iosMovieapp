import Foundation
import CoreData


extension MoviePhotoListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviePhotoListEntity> {
        return NSFetchRequest<MoviePhotoListEntity>(entityName: "MoviePhotoListEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension MoviePhotoListEntity {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: MoviePhotosEntity)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: MoviePhotosEntity)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension MoviePhotoListEntity : Identifiable {

}
