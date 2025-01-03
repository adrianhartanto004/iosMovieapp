import SwiftUI
import SDWebImageSwiftUI
import SwiftUIIntrospect

struct NowPlayingMoviesListView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel = 
        ViewModelProvider.getInstance().provideNowPlayingMoviesListViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: { 
                    Image(systemName: "chevron.left")
                }
                Text("More Now Playing Movies")
                    .padding(.leading, 16)
            }
            .padding(.horizontal, 16)
            List(viewModel.nowPlayingMovies, id: \.id) { movie in
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
            .introspect(.list, on: .iOS(.v13, .v14, .v15)) { tableView in
                tableView.separatorStyle = .none
            }
            .introspect(.list, on: .iOS(.v16, .v17, .v18)) { collectionView in
                if #available(iOS 14.0, *) {
                    var config = UICollectionLayoutListConfiguration(appearance: .plain)
                    config.showsSeparators = false
                    let layout = UICollectionViewCompositionalLayout.list(using: config)
                    collectionView.collectionViewLayout = layout 
                }
            }
            .listStyle(PlainListStyle())
            .padding(.top, 16)
        }
        .padding(.top, 60)
        .onAppear {
            viewModel.loadNowPlayingMovies()
            viewModel.fetchNowPlayingMovies()
        }
        //        .background(Color.homeBackground)
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden()
    }
    
    private func shouldLoadMore(movieId: Int) -> Bool {
        let isBottomNowPlayingMoviesItemNil = viewModel.bottomNowPlayingMoviesItem == nil
        let isCurrentMovieIdAtBottom = movieId == viewModel.bottomNowPlayingMoviesItem?.id 
        let isNowPlayingMoviesLoading = viewModel.isNowPlayingMoviesLoading
        let isLoadMoreMoviesLoading = viewModel.isLoadMoreMoviesLoading
        
        return !isBottomNowPlayingMoviesItemNil && isCurrentMovieIdAtBottom && !isNowPlayingMoviesLoading && !isLoadMoreMoviesLoading
    }
}
