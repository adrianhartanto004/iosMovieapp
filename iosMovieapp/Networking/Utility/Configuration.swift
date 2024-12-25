import Foundation

enum BaseURLType {
    case baseApi
    
    var desc: URL {
        switch self {
        case .baseApi:
            #if DEBUG
            return URL.initURL("https://api.themoviedb.org/3")!
            #else
            return URL.initURL("https://api.themoviedb.org/3")!
            #endif
        }
    }
}
