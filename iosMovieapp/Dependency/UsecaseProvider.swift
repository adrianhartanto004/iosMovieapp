import Foundation

class UsecaseProvider {
    private static let instance = UsecaseProvider()
    
    static func getInstance() -> UsecaseProvider {
        return instance
    }
    
    func provideFetchNowPlayingMoviesUsecase() -> FetchNowPlayingMoviesUsecase {
        let moviesRepository = RepositoryProvider.getInstance().provideMoviesRepository()
        return FetchNowPlayingMoviesUsecaseImpl(moviesRepository: moviesRepository)
    }
    
    func provideGetNowPlayingMoviesUsecase() -> GetNowPlayingMoviesUsecase {
        let moviesRepository = RepositoryProvider.getInstance().provideMoviesRepository()
        return GetNowPlayingMoviesUsecaseImpl(moviesRepository: moviesRepository)
    }
}
