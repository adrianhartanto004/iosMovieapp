import Foundation
import Combine

protocol MovieRepository {
    func fetchNowPlayingMovies() -> AnyPublisher<Void, Error>
    func getNowPlayingMovies(limit: Int?) -> AnyPublisher<[NowPlayingMovies], Error>
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<Void, Error>
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error>
    func fetchMovieCredits(movieId: Int) -> AnyPublisher<Void, Error>
    func getMovieCasts(movieId: Int) -> AnyPublisher<[Cast], Error>
    func fetchMoviePhotos(movieId: Int) -> AnyPublisher<Void, Error>
    func getMoviePhotos(movieId: Int) -> AnyPublisher<[Photo], Error>
    func fetchRecommendedMovies(movieId: Int) -> AnyPublisher<RecommendedMoviesList, Error>
    func fetchAuthorReviews(movieId: Int) -> AnyPublisher<Void, Error>
    func getAuthorReviews(movieId: Int) -> AnyPublisher<[AuthorReview], Error>
}

class MovieRepositoryImpl: MovieRepository {
    let nowPlayingMoviesService: NowPlayingMoviesService
    let nowPlayingMoviesDao: NowPlayingMoviesDao
    let movieDetailService: MovieDetailService
    let movieDetailDao: MovieDetailDao
    let movieCastsDao: MovieCastsDao
    let moviePhotosDao: MoviePhotosDao
    let movieAuthorReviewsDao: MovieAuthorReviewsDao
    
    init(
        nowPlayingMoviesService: NowPlayingMoviesService,
        nowPlayingMoviesDao: NowPlayingMoviesDao,
        movieDetailService: MovieDetailService,
        movieDetailDao: MovieDetailDao,
        movieCastsDao: MovieCastsDao,
        moviePhotosDao: MoviePhotosDao,
        movieAuthorReviewsDao: MovieAuthorReviewsDao
    ) {
        self.nowPlayingMoviesService = nowPlayingMoviesService
        self.nowPlayingMoviesDao = nowPlayingMoviesDao
        self.movieDetailService = movieDetailService
        self.movieDetailDao = movieDetailDao
        self.movieCastsDao = movieCastsDao
        self.moviePhotosDao = moviePhotosDao
        self.movieAuthorReviewsDao = movieAuthorReviewsDao
    }
    
    func fetchNowPlayingMovies() -> AnyPublisher<Void, Error> {
        return nowPlayingMoviesService
            .fetch()
            .flatMap { [weak self] movies -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.nowPlayingMoviesDao.deleteAll()
                    .flatMap{ self.nowPlayingMoviesDao.insertAll(movies.nowPlayingMovies) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getNowPlayingMovies(limit: Int?) -> AnyPublisher<[NowPlayingMovies], Error> {
        return self.nowPlayingMoviesDao.fetch(limit: limit)
    }
    
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieDetailService
            .fetchMovieDetail(movieId: movieId)
            .flatMap { [weak self] movieDetail -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.movieDetailDao.deleteMovieDetail(movieId: movieId)
                    .flatMap { self.movieDetailDao.insert(movieDetail) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        return self.movieDetailDao.fetch(movieId: movieId)
    }
    
    func fetchMovieCredits(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieDetailService
            .fetchMovieCredits(movieId: movieId)
            .flatMap { [weak self] movieCredits -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.movieCastsDao.deleteMovieCredit(movieId: movieId)
                    .flatMap { self.movieCastsDao.insertAll(movieId: movieId, movieCredits.cast) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getMovieCasts(movieId: Int) -> AnyPublisher<[Cast], Error> {
        return self.movieCastsDao.fetch(movieId: movieId)
    }
    
    func fetchMoviePhotos(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieDetailService
            .fetchMoviePhotos(movieId: movieId)
            .flatMap { [weak self] moviePhotoList -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.moviePhotosDao.deleteMoviePhoto(movieId: movieId)
                    .flatMap { self.moviePhotosDao.insertAll(movieId: movieId, moviePhotoList.photos ?? []) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getMoviePhotos(movieId: Int) -> AnyPublisher<[Photo], Error> {
        return self.moviePhotosDao.fetch(movieId: movieId)
    }
    
    func fetchRecommendedMovies(movieId: Int) -> AnyPublisher<RecommendedMoviesList, Error> {
        var recommendedMoviesList: RecommendedMoviesList?
        return movieDetailService
            .fetchRecommendedMovies(movieId: movieId)
            .eraseToAnyPublisher()
    }
    
    func fetchAuthorReviews(movieId: Int) -> AnyPublisher<Void, Error> {
        return movieDetailService
            .fetchAuthorReviews(movieId: movieId)
            .flatMap { [weak self] authorReviewList -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.movieAuthorReviewsDao.deleteMovieAuthorReviews(movieId: movieId)
                    .flatMap { self.movieAuthorReviewsDao.insertAll(movieId: movieId, authorReviewList.authorReviews) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getAuthorReviews(movieId: Int) -> AnyPublisher<[AuthorReview], Error> {
        return self.movieAuthorReviewsDao.fetch(movieId: movieId)
    }
}
