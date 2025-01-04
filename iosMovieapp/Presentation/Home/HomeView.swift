import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel =
        ViewModelProvider.getInstance().provideHomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    headerView
                    nowPlayingMoviesView
                }
                .padding(.top, 60)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            if viewModel.nowPlayingMovies.isEmpty {
                viewModel.loadNowPlayingMovies()
                viewModel.fetchNowPlayingMovies()
            }
        }
        .edgesIgnoringSafeArea([.all])
    }
}

extension HomeView {
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Text("NOW PLAYING")
                .foregroundColor(Color.generalText)
            Spacer()
            NavigationLink { 
                NowPlayingMoviesListView()
            } label: { 
                Text("Show all")
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var nowPlayingMoviesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                if viewModel.moviesError != nil {
                    Button {
                        viewModel.loadNowPlayingMovies()
                        viewModel.fetchNowPlayingMovies()
                    } label: {
                        HStack {
                            Text("Retry Fetch Now Playing Movies")
                                .foregroundColor(Color.generalText)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(Color.buttonBackground)
                        }
                        .cornerRadius(24)
                    }
                    .padding(16)
                } else {
                    HomeNowPlayingMoviesView(
                        isNowPlayingMoviesLoading: $viewModel.isNowPlayingMoviesLoading, 
                        nowPlayingMovies: viewModel.nowPlayingMovies
                    )
                }
            }
            .padding(.top, 14)
        }
    }
}

#Preview {
    HomeView()
}
