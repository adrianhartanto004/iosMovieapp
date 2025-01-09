import SwiftUI
import SDWebImageSwiftUI

struct NowPlayingMoviesView: View {
    @ObservedObject var viewModel: NowPlayingMoviesListViewModel
    
    var body: some View {
        ForEach(viewModel.nowPlayingMovies, id: \.id) { movie in
            NavigationLink {
                MovieDetailView(movieId: movie.id)
            } label: {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(movie.posterPath)"))
                            .resizable()
                            .placeholder { 
                                Rectangle().foregroundColor(.gray)
                                    .shimmering()
                            }
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.size.width / 2.3, height: UIScreen.main.bounds.size.height / 3) 
                            .cornerRadius(16)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        Text(movie.title)
                            .padding(.top, 10)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.01f", movie.voteAverage))
                            Text("(\(movie.voteCount))")
                        }
                        Spacer()
                    }
                }
                .onAppear {
                    if shouldLoadMore(movieId: movie.id) {
                        if viewModel.isFirstFetchSuccessful {
                            viewModel.loadMoreNowPlayingMovies()
                        } else {
                            viewModel.fetchNowPlayingMovies() // refresh data
                        }
                    }
                }
            }
        }
        if viewModel.isLoadMoreMoviesLoading {
            NowPlayingMoviesShimmerView()
        }
    }
    
    private func shouldLoadMore(movieId: Int) -> Bool {
        let isBottomNowPlayingMoviesItemNil = viewModel.bottomNowPlayingMoviesItem == nil
        let isCurrentMovieIdAtBottom = movieId == viewModel.bottomNowPlayingMoviesItem?.id 
        let isNowPlayingMoviesLoading = viewModel.isNowPlayingMoviesLoading
        let isLoadMoreMoviesLoading = viewModel.isLoadMoreMoviesLoading
        
        return !isBottomNowPlayingMoviesItemNil && isCurrentMovieIdAtBottom && !isNowPlayingMoviesLoading && !isLoadMoreMoviesLoading
    }
}
