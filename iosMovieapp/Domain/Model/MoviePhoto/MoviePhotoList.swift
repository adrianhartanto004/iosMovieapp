import Foundation

struct MoviePhotoList: Codable, Equatable {    
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case photos = "backdrops"
    }
}

extension MoviePhotoList {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos) ?? []
    }
}

extension MoviePhotoListEntity: ManagedEntity {}
