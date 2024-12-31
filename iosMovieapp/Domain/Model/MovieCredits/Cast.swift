import Foundation

struct Cast: Codable, Equatable {    
    let castId: Int
    let name: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castId = "cast_id"
        case name
        case profilePath = "profile_path"
    }
}

extension Cast {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        castId = try values.decodeIfPresent(Int.self, forKey: .castId) ?? 0
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath) ?? ""
    }
}

extension MovieCastsEntity: ManagedEntity {}
