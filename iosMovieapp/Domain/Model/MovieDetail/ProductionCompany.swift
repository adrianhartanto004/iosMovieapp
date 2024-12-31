import Foundation

struct ProductionCompany: Codable, Equatable {    
    let id: Int
    let name: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originCountry = "origin_country"
    }
}

extension ProductionCompany {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        originCountry = try values.decodeIfPresent(String.self, forKey: .originCountry) ?? ""
    }
}

extension MovieDetailProductionCompaniesEntity: ManagedEntity {}
