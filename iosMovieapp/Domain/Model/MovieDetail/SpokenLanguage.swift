import Foundation

struct SpokenLanguage: Codable, Equatable {    
    let englishName: String?
    let isoDate: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case isoDate = "iso_3166_1"
        case name
    }
}

extension SpokenLanguage {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        englishName = try values.decodeIfPresent(String.self, forKey: .englishName) ?? ""
        isoDate = try values.decodeIfPresent(String.self, forKey: .isoDate) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
