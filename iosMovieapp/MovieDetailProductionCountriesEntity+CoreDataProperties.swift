import Foundation
import CoreData


extension MovieDetailProductionCountriesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetailProductionCountriesEntity> {
        return NSFetchRequest<MovieDetailProductionCountriesEntity>(entityName: "MovieDetailProductionCountriesEntity")
    }

    @NSManaged public var isoDate: String?
    @NSManaged public var index: Int32
    @NSManaged public var name: String?
    @NSManaged public var productionCountriesRelation: MovieDetailEntity?

}

extension MovieDetailProductionCountriesEntity : Identifiable {

}
