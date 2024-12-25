import Foundation

class RepositoryProvider {
    private static let instance = RepositoryProvider()
    
    static func getInstance() -> RepositoryProvider {
        return instance
    }
    
    func provideMoviesRepository() -> MoviesRepository {
        let nowPlayingMoviesService = ServiceProvider.getInstance().provideNowPlayingMoviesService()
        let nowPlayingMoviesDao = DatabaseProvider.getInstance().provideNowPlayingMoviesDao()
        
        return MoviesRepositoryImpl(
            nowPlayingMoviesService: nowPlayingMoviesService,
            nowPlayingMoviesDao: nowPlayingMoviesDao
        )
    }
}
