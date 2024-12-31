import Foundation

struct MovieCreditList: Codable, Equatable {    
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
        case crew
    }
}

extension MovieCreditList {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        cast = try values.decode([Cast].self, forKey: .cast)
        crew = try values.decode([Crew].self, forKey: .crew)
    }
}

extension MovieCreditListEntity: ManagedEntity {}
