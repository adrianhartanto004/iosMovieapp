import Foundation

struct GenreList: Codable, Equatable {    
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
}

extension GenreList {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genres = try values.decode([Genre].self, forKey: .genres)
    }
}
