import Foundation

enum Constants {
    enum EndpointUrls {
        static let fetchNowPlayingMovies = "/movie/now_playing"
        static let baseImage = "https://image.tmdb.org/t/p/w500/"
        static let movieDetail = "/movie/"
        static let fetchMovieCredits = "/credits"
        static let fetchMovieImages = "/images"
        static let fetchMovieRecommendedMovies = "/recommendations"
        static let fetchMovieAuthorReviews = "/reviews"
    }
    
    enum DBName {
        static let nowPlayingMoviesEntity = "NowPlayingMoviesEntity"
        static let movieDetailEntity = "MovieDetailEntity"
        static let movieCreditListEntity = "MovieCreditListEntity"
        static let moviePhotoListEntity = "MoviePhotoListEntity"
    }
}
