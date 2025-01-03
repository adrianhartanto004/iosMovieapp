import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var isNowPlayingMoviesLoading = false
    @Published var nowPlayingMovies: [NowPlayingMovies] = []
    @Published var moviesError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let fetchNowPlayingMoviesUsecase: FetchNowPlayingMoviesUsecase
    private let getNowPlayingMoviesUsecase: GetNowPlayingMoviesUsecase
    
    init(
        _ fetchNowPlayingMoviesUsecase: FetchNowPlayingMoviesUsecase,
        _ getNowPlayingMoviesUsecase: GetNowPlayingMoviesUsecase
    ) {
        self.fetchNowPlayingMoviesUsecase = fetchNowPlayingMoviesUsecase
        self.getNowPlayingMoviesUsecase = getNowPlayingMoviesUsecase
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func fetchNowPlayingMovies() {
        moviesError = nil
        isNowPlayingMoviesLoading = true
        fetchNowPlayingMoviesUsecase.execute()
            .flatMap { [weak self] _ -> AnyPublisher<[NowPlayingMovies], Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "HomeViewModel", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.getNowPlayingMoviesUsecase.execute(limit: 20)
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
    
    func loadNowPlayingMovies() {
        moviesError = nil
        isNowPlayingMoviesLoading = true
        self.getNowPlayingMoviesUsecase.execute(limit: 20)
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
            .store(in: &self.cancellables)
    }
}
