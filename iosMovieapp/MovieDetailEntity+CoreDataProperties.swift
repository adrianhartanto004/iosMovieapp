import Foundation
import CoreData


extension MovieDetailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetailEntity> {
        return NSFetchRequest<MovieDetailEntity>(entityName: "MovieDetailEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var overview: String?
    @NSManaged public var budget: Int32
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32
    @NSManaged public var releaseDate: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var revenue: Int32
    @NSManaged public var genres: NSSet?
    @NSManaged public var productionCompanies: NSSet?
    @NSManaged public var productionCountries: NSSet?

}

// MARK: Generated accessors for genres
extension MovieDetailEntity {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: MovieDetailGenresEntity)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: MovieDetailGenresEntity)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}

// MARK: Generated accessors for productionCompanies
extension MovieDetailEntity {

    @objc(addProductionCompaniesObject:)
    @NSManaged public func addToProductionCompanies(_ value: MovieDetailProductionCompaniesEntity)

    @objc(removeProductionCompaniesObject:)
    @NSManaged public func removeFromProductionCompanies(_ value: MovieDetailProductionCompaniesEntity)

    @objc(addProductionCompanies:)
    @NSManaged public func addToProductionCompanies(_ values: NSSet)

    @objc(removeProductionCompanies:)
    @NSManaged public func removeFromProductionCompanies(_ values: NSSet)

}

// MARK: Generated accessors for productionCountries
extension MovieDetailEntity {

    @objc(addProductionCountriesObject:)
    @NSManaged public func addToProductionCountries(_ value: MovieDetailProductionCountriesEntity)

    @objc(removeProductionCountriesObject:)
    @NSManaged public func removeFromProductionCountries(_ value: MovieDetailProductionCountriesEntity)

    @objc(addProductionCountries:)
    @NSManaged public func addToProductionCountries(_ values: NSSet)

    @objc(removeProductionCountries:)
    @NSManaged public func removeFromProductionCountries(_ values: NSSet)

}

extension MovieDetailEntity : Identifiable {

}
