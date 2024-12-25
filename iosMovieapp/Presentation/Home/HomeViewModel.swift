import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var isNowPlayingMoviesLoading = false
    @Published var nowPlayingMovies: [NowPlayingMovies] = []
    @Published var moviesError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fetchNewEpisodesUsecase: FetchNowPlayingMoviesUsecase
    private let getNowPlayingMoviesUsecase: GetNowPlayingMoviesUsecase
    
    init(
        _ fetchNewEpisodesUsecase: FetchNowPlayingMoviesUsecase,
        _ getNowPlayingMoviesUsecase: GetNowPlayingMoviesUsecase
    ) {
        self.fetchNewEpisodesUsecase = fetchNewEpisodesUsecase
        self.getNowPlayingMoviesUsecase = getNowPlayingMoviesUsecase
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func fetchNewEpisodes() {
        moviesError = nil
        fetchNewEpisodesUsecase.execute()
            .flatMap { [weak self] _ -> AnyPublisher<[NowPlayingMovies], Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "HomeViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getNowPlayingMoviesUsecase.execute()
            }
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
            }
            .store(in: &cancellables)
    }
    
    func loadNewEpisodesMedia() {
        moviesError = nil
        isNowPlayingMoviesLoading = true
        getNowPlayingMoviesUsecase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.moviesError = error
                    self?.isNowPlayingMoviesLoading = false
                }
            } receiveValue: { [weak self] nowPlayingMovies in
                self?.nowPlayingMovies = nowPlayingMovies
            }
            .store(in: &self.cancellables)
    }
    
    func loadMore() {
        
    }
}
