import Foundation

struct MovieDetail: Codable, Equatable {    
    let budget: Int?
    let genres: [Genre]?
    let id: Int
    let originalLanguage: String?
    let overview: String?
    let pospterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let title: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case budget
        case genres
        case id
        case originalLanguage = "original_language"
        case overview
        case pospterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDetail {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        budget = try values.decodeIfPresent(Int.self, forKey: .budget) ?? 0
        genres = try values.decodeIfPresent([Genre].self, forKey: .genres) ?? []
        id = try values.decode(Int.self, forKey: .id)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage) ?? ""
        overview = try values.decodeIfPresent(String.self, forKey: .overview) ?? ""
        pospterPath = try values.decodeIfPresent(String.self, forKey: .pospterPath) ?? ""
        productionCompanies = try values.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies) ?? []
        productionCountries = try values.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries) ?? []
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        revenue = try values.decodeIfPresent(Int.self, forKey: .revenue) ?? 0
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)  ?? 0
    }
}

extension MovieDetailEntity: ManagedEntity {}
