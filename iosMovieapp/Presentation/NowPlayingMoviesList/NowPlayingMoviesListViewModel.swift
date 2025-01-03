import Combine
import Foundation

class NowPlayingMoviesListViewModel: ObservableObject {
    @Published var isNowPlayingMoviesLoading = false
    @Published var isLoadMoreMoviesLoading = false
    @Published var nowPlayingMovies: [NowPlayingMovies] = []
    @Published var bottomNowPlayingMoviesItem: NowPlayingMovies?
    @Published var moviesError: Error?
    @Published var loadMoreError: Error?
    var currentPage = 1
    var isFirstFetchSuccessful = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fetchNowPlayingMoviesUsecase: FetchNowPlayingMoviesUsecase
    private let getNowPlayingMoviesUsecase: GetNowPlayingMoviesUsecase
    private let loadMoreNowPlayingMoviesUsecase: LoadMoreNowPlayingMoviesUsecase
    
    init(
        _ fetchNowPlayingMoviesUsecase: FetchNowPlayingMoviesUsecase,
        _ getNowPlayingMoviesUsecase: GetNowPlayingMoviesUsecase,
        _ loadMoreNowPlayingMoviesUsecase: LoadMoreNowPlayingMoviesUsecase
    ) {
        self.fetchNowPlayingMoviesUsecase = fetchNowPlayingMoviesUsecase
        self.getNowPlayingMoviesUsecase = getNowPlayingMoviesUsecase
        self.loadMoreNowPlayingMoviesUsecase = loadMoreNowPlayingMoviesUsecase
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func fetchNowPlayingMovies() {
        moviesError = nil
        currentPage = 1
        isNowPlayingMoviesLoading = true
        fetchNowPlayingMoviesUsecase.execute()
            .flatMap { [weak self] _ -> AnyPublisher<[NowPlayingMovies], Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "NowPlayingMoviesListViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getNowPlayingMoviesUsecase.execute(limit: nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isNowPlayingMoviesLoading = false
                case .failure(let error):
                    self?.moviesError = error
                    self?.isNowPlayingMoviesLoading = false
                    self?.isFirstFetchSuccessful = false
                }
            } receiveValue: { [weak self] nowPlayingMovies in
                self?.nowPlayingMovies = nowPlayingMovies
                self?.bottomNowPlayingMoviesItem = nowPlayingMovies.last
                self?.isFirstFetchSuccessful = true
            }
            .store(in: &cancellables)
    }
    
    func loadNowPlayingMovies() {
        moviesError = nil
        isNowPlayingMoviesLoading = true
        self.getNowPlayingMoviesUsecase.execute(limit: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isNowPlayingMoviesLoading = false
                case .failure(let error):
                    self?.moviesError = error
                    self?.isNowPlayingMoviesLoading = false
                }
            } receiveValue: { [weak self] nowPlayingMovies in
                self?.nowPlayingMovies = nowPlayingMovies
                self?.bottomNowPlayingMoviesItem = nowPlayingMovies.last
            }
            .store(in: &cancellables)
    }
    
    func loadMoreNowPlayingMovies() {
        loadMoreError = nil
        isLoadMoreMoviesLoading = true
        let nextPage = currentPage + 1
        loadMoreNowPlayingMoviesUsecase.execute(page: nextPage)
            .flatMap { [weak self] _ -> AnyPublisher<[NowPlayingMovies], Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "NowPlayingMoviesListViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getNowPlayingMoviesUsecase.execute(limit: nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoadMoreMoviesLoading = false
                case .failure(let error):
                    self?.loadMoreError = error
                    self?.isLoadMoreMoviesLoading = false
                }
            } receiveValue: { [weak self] nowPlayingMovies in
                self?.nowPlayingMovies = nowPlayingMovies
                self?.bottomNowPlayingMoviesItem = nowPlayingMovies.last
                self?.currentPage = nextPage
            }
            .store(in: &cancellables)
    }
}
