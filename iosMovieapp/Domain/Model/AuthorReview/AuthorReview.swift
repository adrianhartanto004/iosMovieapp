import Foundation

struct AuthorReview: Codable, Equatable {    
    let author: String?
    let authorDetails: AuthorDetails?
    let content: String?
    let id: String
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case id
        case updatedAt = "updated_at"
    }
}

extension AuthorReview {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decodeIfPresent(String.self, forKey: .author) ?? ""
        authorDetails = try values.decodeIfPresent(AuthorDetails.self, forKey: .authorDetails)
        content = try values.decodeIfPresent(String.self, forKey: .content) ?? ""
        id = try values.decode(String.self, forKey: .id)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
}

extension MovieAuthorReviewsEntity: ManagedEntity {}
