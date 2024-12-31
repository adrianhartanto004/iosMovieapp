import Foundation

class RepositoryProvider {
    private static let instance = RepositoryProvider()
    
    static func getInstance() -> RepositoryProvider {
        return instance
    }
    
    func provideMovieRepository() -> MovieRepository {
        let nowPlayingMoviesService = ServiceProvider.getInstance().provideNowPlayingMoviesService()
        let nowPlayingMoviesDao = DatabaseProvider.getInstance().provideNowPlayingMoviesDao()
        let movieDetailService = ServiceProvider.getInstance().provideMovieDetailService()
        let movieDetailDao = DatabaseProvider.getInstance().provideMovieDetailDao()
        let movieCastsDao = DatabaseProvider.getInstance().provideMovieCastsDao()
        let moviePhotosDao = DatabaseProvider.getInstance().provideMoviePhotosDao()
        let movieAuthorReviewsDao = DatabaseProvider.getInstance().provideMovieAuthorReviewsDao()
        
        return MovieRepositoryImpl(
            nowPlayingMoviesService: nowPlayingMoviesService,
            nowPlayingMoviesDao: nowPlayingMoviesDao,
            movieDetailService: movieDetailService,
            movieDetailDao: movieDetailDao,
            movieCastsDao: movieCastsDao,
            moviePhotosDao: moviePhotosDao,
            movieAuthorReviewsDao: movieAuthorReviewsDao
        )
    }
}
