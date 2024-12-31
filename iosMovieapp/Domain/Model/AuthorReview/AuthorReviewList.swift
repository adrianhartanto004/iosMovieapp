import Foundation

struct AuthorReviewList: Codable, Equatable {    
    let id: Int
    let page: Int
    let authorReviews: [AuthorReview]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case page
        case authorReviews = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension AuthorReviewList {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        page = try values.decode(Int.self, forKey: .page)
        authorReviews = try values.decode([AuthorReview].self, forKey: .authorReviews)
        totalPages = try values.decode(Int.self, forKey: .totalPages)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
    }
}

extension MovieAuthorReviewListEntity: ManagedEntity {}
