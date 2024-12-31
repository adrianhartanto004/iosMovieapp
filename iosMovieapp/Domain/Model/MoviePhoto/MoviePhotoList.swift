import Foundation

struct MoviePhotoList: Codable, Equatable {    
    let id: Int
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case photos = "backdrops"
    }
}

extension MoviePhotoList {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos) ?? []
    }
}

extension MoviePhotoListEntity: ManagedEntity {}
