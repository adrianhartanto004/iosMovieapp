import Foundation

class ServiceProvider {
    private static let instance = ServiceProvider()
    
    static func getInstance() -> ServiceProvider {
        return instance
    }
    
    func provideNowPlayingMoviesService() -> NowPlayingMoviesService {
        return NowPlayingMoviesServiceImpl()
    }
    
    func provideMovieDetailService() -> MovieDetailService {
        return MovieDetailServiceImpl()
    }
}
