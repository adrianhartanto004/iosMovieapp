import Foundation
import CoreData


extension MovieDetailProductionCompaniesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetailProductionCompaniesEntity> {
        return NSFetchRequest<MovieDetailProductionCompaniesEntity>(entityName: "MovieDetailProductionCompaniesEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var index: Int32
    @NSManaged public var name: String?
    @NSManaged public var originCountry: String?
    @NSManaged public var productionCompaniesRelation: MovieDetailEntity?

}

extension MovieDetailProductionCompaniesEntity : Identifiable {

}
