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
    
    func provideMovieDetailDao() -> MovieDetailDao {
        return MovieDetailDaoImpl(persistentStore: coreDataStack)
    }
    
    func provideMovieCastsDao() -> MovieCastsDao {
        return MovieCastsDaoImpl(persistentStore: coreDataStack)
    }
    
    func provideMoviePhotosDao() -> MoviePhotosDao {
        return MoviePhotosDaoImpl(persistentStore: coreDataStack)
    }
    
    func provideMovieAuthorReviewsDao() -> MovieAuthorReviewsDao {
        return MovieAuthorReviewsDaoImpl(persistentStore: coreDataStack)
    }
}
