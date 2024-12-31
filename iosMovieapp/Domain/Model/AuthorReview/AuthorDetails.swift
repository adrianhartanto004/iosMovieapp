import Foundation

struct AuthorDetails: Codable, Equatable {    
    let avatarPath: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
        case rating
    }
}

extension AuthorDetails {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        avatarPath = try values.decodeIfPresent(String.self, forKey: .avatarPath) ?? ""
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? 0
    }
}
