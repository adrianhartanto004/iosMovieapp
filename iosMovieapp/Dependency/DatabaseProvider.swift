import Foundation

class DatabaseProvider {
    private static let instance = DatabaseProvider()
    
    static func getInstance() -> DatabaseProvider {
        return instance
    }
    
    let coreDataStack = CoreDataStack(version: CoreDataStack.Version.actual)
    
    func provideNowPlayingMoviesDao() -> NowPlayingMoviesDao {
        return NowPlayingMoviesDaoImpl(persistentStore: coreDataStack)
    }
}
