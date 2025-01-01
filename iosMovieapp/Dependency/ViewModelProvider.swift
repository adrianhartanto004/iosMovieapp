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
    
    func provideMovieDetailViewModel() -> MovieDetailViewModel {
        let fetchMovieDetailUsecase = 
            UsecaseProvider.getInstance().provideFetchMovieDetail()
        let getMovieDetailUsecase =
            UsecaseProvider.getInstance().provideGetMovieDetail()
        let fetchMovieCreditsUsecase = 
            UsecaseProvider.getInstance().provideFetchMovieCreditsUsecase()
        let getMovieCastsUsecase =
            UsecaseProvider.getInstance().provideGetMovieCastsUsecase()
        let fetchMoviePhotosUsecase = 
            UsecaseProvider.getInstance().provideFetchMoviePhotosUsecase()
        let getMoviePhotosUsecase = 
            UsecaseProvider.getInstance().provideGetMoviePhotosUsecase()
        let fetchRecommendedMoviesUsecase = 
            UsecaseProvider.getInstance().provideFetchRecommendedMoviesUsecase()
        let fetchAuthorReviewsUsecase = 
            UsecaseProvider.getInstance().provideFetchAuthorReviewsUsecase()
        let getAuthorReviewsUsecase = 
            UsecaseProvider.getInstance().provideGetAuthorReviewsUsecase()
        let addOrRemoveFavouriteMoviesUsecase = 
            UsecaseProvider.getInstance().provideAddOrRemoveFavouriteMoviesUsecase()
        let getIsFavouriteMovieUsecase = 
            UsecaseProvider.getInstance().provideGetIsFavouriteMovieUsecase()
        
        return MovieDetailViewModel(
            fetchMovieDetailUsecase,
            getMovieDetailUsecase,
            fetchMovieCreditsUsecase,
            getMovieCastsUsecase,
            fetchMoviePhotosUsecase,
            getMoviePhotosUsecase,
            fetchRecommendedMoviesUsecase,
            fetchAuthorReviewsUsecase,
            getAuthorReviewsUsecase,
            addOrRemoveFavouriteMoviesUsecase,
            getIsFavouriteMovieUsecase
        )
    }
    
    func provideFavouriteMoviesViewModel() -> FavouriteMoviesViewModel {
        let getFavouriteMoviesUsecase = 
            UsecaseProvider.getInstance().provideGetFavouriteMoviesUsecase()
        
        return FavouriteMoviesViewModel(
            getFavouriteMoviesUsecase
        )
    }
}
