import Combine
import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var isMovieDetailLoading = false
    @Published var isMovieCastsLoading = false
    @Published var isMoviePhotosLoading = false
    @Published var isMovieAuthorReviewsLoading = false
    @Published var movieDetail: MovieDetail?
    @Published var movieCasts: [Cast] = []
    @Published var moviePhotos: [Photo] = []
    @Published var recommendedMovies: [RecommendedMovies] = []
    @Published var authorReviews: [AuthorReview] = []
    @Published var isFavouriteMovie = false
    @Published var movieDetailError: Error?
    @Published var movieCastsError: Error?
    @Published var moviePhotosError: Error?
    @Published var movieAuthorReviewsError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fetchMovieDetailUsecase: FetchMovieDetailUsecase
    private let getMovieDetailUsecase: GetMovieDetailUsecase
    private let fetchMovieCreditsUsecase: FetchMovieCreditsUsecase
    private let getMovieCastsUsecase: GetMovieCastsUsecase
    private let fetchMoviePhotosUsecase: FetchMoviePhotosUsecase
    private let getMoviePhotosUsecase: GetMoviePhotosUsecase
    private let fetchRecommendedMoviesUsecase: FetchRecommendedMoviesUsecase
    private let fetchAuthorReviewsUsecase: FetchAuthorReviewsUsecase
    private let getAuthorReviewsUsecase: GetAuthorReviewsUsecase
    private let addOrRemoveFavouriteMovieUsecase: AddOrRemoveFavouriteMovieUsecase
    private let getIsFavouriteMovieUsecase: GetIsFavouriteMovieUsecase
    
    init(
        _ fetchMovieDetailUsecase: FetchMovieDetailUsecase,
        _ getMovieDetailUsecase: GetMovieDetailUsecase,
        _ fetchMovieCreditsUsecase: FetchMovieCreditsUsecase,
        _ getMovieCastsUsecase: GetMovieCastsUsecase,
        _ fetchMoviePhotosUsecase: FetchMoviePhotosUsecase,
        _ getMoviePhotosUsecase: GetMoviePhotosUsecase,
        _ fetchRecommendedMoviesUsecase: FetchRecommendedMoviesUsecase,
        _ fetchAuthorReviewsUsecase: FetchAuthorReviewsUsecase,
        _ getAuthorReviewsUsecase: GetAuthorReviewsUsecase,
        _ addOrRemoveFavouriteMovieUsecase: AddOrRemoveFavouriteMovieUsecase,
        _ getIsFavouriteMovieUsecase: GetIsFavouriteMovieUsecase
    ) {
        self.fetchMovieDetailUsecase = fetchMovieDetailUsecase
        self.getMovieDetailUsecase = getMovieDetailUsecase
        self.fetchMovieCreditsUsecase = fetchMovieCreditsUsecase
        self.getMovieCastsUsecase = getMovieCastsUsecase
        self.fetchMoviePhotosUsecase = fetchMoviePhotosUsecase
        self.getMoviePhotosUsecase = getMoviePhotosUsecase
        self.fetchRecommendedMoviesUsecase = fetchRecommendedMoviesUsecase
        self.fetchAuthorReviewsUsecase = fetchAuthorReviewsUsecase
        self.getAuthorReviewsUsecase = getAuthorReviewsUsecase
        self.addOrRemoveFavouriteMovieUsecase = addOrRemoveFavouriteMovieUsecase
        self.getIsFavouriteMovieUsecase = getIsFavouriteMovieUsecase
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func fetchMovieDetail(movieId: Int) {
        movieDetailError = nil
        isMovieDetailLoading = true
        fetchMovieDetailUsecase.execute(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] _ -> AnyPublisher<MovieDetail, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieDetailViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getMovieDetailUsecase.execute(movieId: movieId)
            }
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] movieDetail -> AnyPublisher<Bool, Error> in
                self?.movieDetail = movieDetail
                guard let self = self else {
                    return Fail(error: NSError(domain: "MovieDetailViewModel", code: 0, userInfo: ["message": "nil self"]))
                        .eraseToAnyPublisher()
                }
                return self.getIsFavouriteMovieUsecase.execute(movieId: movieId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMovieDetailLoading = false
                case .failure(let error):
                    self?.movieDetailError = error
                    self?.isMovieDetailLoading = false
                }
            } receiveValue: { [weak self] isFavouriteMovie in
                self?.isFavouriteMovie = isFavouriteMovie
            }
            .store(in: &cancellables)
    }
    
    func loadMovieDetail(movieId: Int) {
        movieDetailError = nil
        isMovieDetailLoading = true
        getMovieDetailUsecase.execute(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] movieDetail -> AnyPublisher<Bool, Error> in
                self?.movieDetail = movieDetail
                guard let self = self else {
                    return Fail(error: NSError(domain: "MovieDetailViewModel", code: 0, userInfo: ["message": "nil self"]))
                        .eraseToAnyPublisher()
                }
                return self.getIsFavouriteMovieUsecase.execute(movieId: movieId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMovieDetailLoading = false
                case .failure(let error):
                    self?.movieDetailError = error
                    self?.isMovieDetailLoading = false
                }
            } receiveValue: { [weak self] isFavouriteMovie in
                self?.isFavouriteMovie = isFavouriteMovie
            }
            .store(in: &cancellables)
    }
    
    func fetchMovieCasts(movieId: Int) {
        movieCastsError = nil
        isMovieCastsLoading = true
        fetchMovieCreditsUsecase.execute(movieId: movieId)
            .flatMap { [weak self] _ -> AnyPublisher<[Cast], Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieDetailViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getMovieCastsUsecase.execute(movieId: movieId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMovieCastsLoading = false
                case .failure(let error):
                    self?.movieCastsError = error
                    self?.isMovieCastsLoading = false
                }
            } receiveValue: { [weak self] casts in
                self?.movieCasts = casts
            }
            .store(in: &cancellables)
    }
    
    func loadMovieCasts(movieId: Int) {
        movieCastsError = nil
        isMovieCastsLoading = true
        getMovieCastsUsecase.execute(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMovieCastsLoading = false
                case .failure(let error):
                    self?.movieCastsError = error
                    self?.isMovieCastsLoading = false
                }
            } receiveValue: { [weak self] casts in
                self?.movieCasts = casts
            }
            .store(in: &self.cancellables)
    }
    
    func fetchMoviePhotos(movieId: Int) {
        movieCastsError = nil
        isMoviePhotosLoading = true
        fetchMoviePhotosUsecase.execute(movieId: movieId)
            .flatMap { [weak self] _ -> AnyPublisher<[Photo], Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieDetailViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getMoviePhotosUsecase.execute(movieId: movieId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMoviePhotosLoading = false
                case .failure(let error):
                    self?.moviePhotosError = error
                    self?.isMoviePhotosLoading = false
                }
            } receiveValue: { [weak self] photos in
                self?.moviePhotos = photos
            }
            .store(in: &cancellables)
    }
    
    func loadMoviePhotos(movieId: Int) {
        moviePhotosError = nil
        isMoviePhotosLoading = true
        getMoviePhotosUsecase.execute(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMoviePhotosLoading = false
                case .failure(let error):
                    self?.moviePhotosError = error
                    self?.isMoviePhotosLoading = false
                }
            } receiveValue: { [weak self] photos in
                self?.moviePhotos = photos
            }
            .store(in: &cancellables)
    }
    
    func fetchAuthorReviews(movieId: Int) {
        movieAuthorReviewsError = nil
        isMovieAuthorReviewsLoading = true
        fetchAuthorReviewsUsecase.execute(movieId: movieId)
            .flatMap { [weak self] _ -> AnyPublisher<[AuthorReview], Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieDetailViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getAuthorReviewsUsecase.execute(movieId: movieId)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMovieAuthorReviewsLoading = false
                case .failure(let error):
                    self?.movieAuthorReviewsError = error
                    self?.isMovieAuthorReviewsLoading = false
                }
            } receiveValue: { [weak self] authorReviews in
                self?.authorReviews = authorReviews
            }
            .store(in: &cancellables)
    }
    
    func loadAuthorReviews(movieId: Int) {
        movieAuthorReviewsError = nil
        isMovieAuthorReviewsLoading = true
        getAuthorReviewsUsecase.execute(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isMovieAuthorReviewsLoading = false
                case .failure(let error):
                    self?.movieAuthorReviewsError = error
                    self?.isMovieAuthorReviewsLoading = false
                }
            } receiveValue: { [weak self] authorReviews in
                self?.authorReviews = authorReviews
            }
            .store(in: &cancellables)
    }
    
    func addOrRemoveFavouriteMovie(movieDetail: MovieDetail) {
        addOrRemoveFavouriteMovieUsecase.execute(movieDetail: movieDetail)
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MovieDetailViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getIsFavouriteMovieUsecase.execute(movieId: movieDetail.id)
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { [weak self] isFavouriteMovie in
                self?.isFavouriteMovie = isFavouriteMovie
            }
            .store(in: &cancellables)
    }
}
