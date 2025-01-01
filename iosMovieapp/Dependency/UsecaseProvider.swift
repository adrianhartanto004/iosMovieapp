import Foundation

class UsecaseProvider {
    private static let instance = UsecaseProvider()
    
    static func getInstance() -> UsecaseProvider {
        return instance
    }
    
    func provideFetchNowPlayingMoviesUsecase() -> FetchNowPlayingMoviesUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return FetchNowPlayingMoviesUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideGetNowPlayingMoviesUsecase() -> GetNowPlayingMoviesUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return GetNowPlayingMoviesUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideFetchMovieDetail() -> FetchMovieDetailUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return FetchMovieDetailUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideGetMovieDetail() -> GetMovieDetailUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return GetMovieDetailUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideFetchMovieCreditsUsecase() -> FetchMovieCreditsUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return FetchMovieCreditsUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideGetMovieCastsUsecase() -> GetMovieCastsUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return GetMovieCastsUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideFetchMoviePhotosUsecase() -> FetchMoviePhotosUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return FetchMoviePhotosUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideGetMoviePhotosUsecase() -> GetMoviePhotosUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return GetMoviePhotosUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideFetchRecommendedMoviesUsecase() -> FetchRecommendedMoviesUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return FetchRecommendedMoviesUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideFetchAuthorReviewsUsecase() -> FetchAuthorReviewsUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return FetchAuthorReviewsUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideGetAuthorReviewsUsecase() -> GetAuthorReviewsUsecase {
        let movieRepository = RepositoryProvider.getInstance().provideMovieRepository()
        return GetAuthorReviewsUsecaseImpl(movieRepository: movieRepository)
    }
    
    func provideAddOrRemoveFavouriteMoviesUsecase() -> AddOrRemoveFavouriteMovieUsecase {
        let favouriteMovieRepository = RepositoryProvider.getInstance().provideFavouriteMoviesRepository()
        return AddOrRemoveFavouriteMovieUsecaseImpl(favouriteMovieRepository: favouriteMovieRepository)
    }
    
    func provideGetIsFavouriteMovieUsecase() -> GetIsFavouriteMovieUsecase {
        let favouriteMovieRepository = RepositoryProvider.getInstance().provideFavouriteMoviesRepository()
        return GetIsFavouriteMovieUsecaseImpl(favouriteMovieRepository: favouriteMovieRepository)
    }
    
    func provideGetFavouriteMoviesUsecase() -> GetFavouriteMoviesUsecase {
        let favouriteMovieRepository = RepositoryProvider.getInstance().provideFavouriteMoviesRepository()
        return GetFavouriteMoviesUsecaseImpl(favouriteMovieRepository: favouriteMovieRepository)
    }
}
