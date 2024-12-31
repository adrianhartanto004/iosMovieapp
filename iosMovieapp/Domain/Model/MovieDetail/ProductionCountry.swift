import Foundation

struct ProductionCountry: Codable, Equatable {    
    let isoDate: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case isoDate = "iso_3166_1"
        case name
    }
}

extension ProductionCountry {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isoDate = try values.decodeIfPresent(String.self, forKey: .isoDate) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}

extension MovieDetailProductionCountriesEntity: ManagedEntity {}
