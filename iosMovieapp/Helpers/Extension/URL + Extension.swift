import Foundation

extension URL {
    static func initURL(_ string: String) -> URL? {
        if #available(iOS 17.0, *) {
            return URL(string: string, encodingInvalidCharacters: false)
        } else {
            return URL(string: string)
        }
    }
}
