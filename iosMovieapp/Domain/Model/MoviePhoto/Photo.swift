import Foundation

struct Photo: Codable, Equatable, Hashable {    
    let filePath: String?
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

extension Photo {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filePath = try values.decodeIfPresent(String.self, forKey: .filePath) ?? ""
    }
}

extension MoviePhotosEntity: ManagedEntity {}
