import Combine
import Foundation

class FavouriteMoviesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var nowPlayingMovies: [NowPlayingMovies] = []
    @Published var favouriteMoviesError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let getFavouriteMoviesUsecase: GetFavouriteMoviesUsecase
    
    init(
        _ getFavouriteMoviesUsecase: GetFavouriteMoviesUsecase
    ) {
        self.getFavouriteMoviesUsecase = getFavouriteMoviesUsecase
    }
    
    deinit {
        cancellables.removeAll()
    }

    func loadFavouriteMovies() {
        favouriteMoviesError = nil
        isLoading = true
        getFavouriteMoviesUsecase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.favouriteMoviesError = error
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] nowPlayingMovies in
                self?.nowPlayingMovies = nowPlayingMovies
            }
            .store(in: &self.cancellables)
    }
}
