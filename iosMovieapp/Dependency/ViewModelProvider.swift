import Foundation

class ViewModelProvider {
    private static let instance = ViewModelProvider()
    
    static func getInstance() -> ViewModelProvider {
        return instance
    }
    
    func provideHomeViewModel() -> HomeViewModel {
        let fetchNowPlayingMovies = 
            UsecaseProvider.getInstance().provideFetchNowPlayingMoviesUsecase()
        let getNowPlayingMovies =
            UsecaseProvider.getInstance().provideGetNowPlayingMoviesUsecase()
        
        return HomeViewModel(
            fetchNowPlayingMovies,
            getNowPlayingMovies
        )
    }
}
