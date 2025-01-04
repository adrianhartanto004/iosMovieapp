import SwiftUI

struct HomeNowPlayingMoviesView: View {
    @Binding var isNowPlayingMoviesLoading: Bool
    let nowPlayingMovies: [NowPlayingMovies]

    var body: some View {
        if isNowPlayingMoviesLoading {
            ForEach(0..<5) { _ in
                HomeNowPlayingMoviesShimmerView()
            }
        } else {
            ForEach(nowPlayingMovies, id: \.id) { movie in
                HomeNowPlayingMoviesItemView(movie: movie)
                    .padding(.trailing, movie.id == nowPlayingMovies.last!.id ? 20 : 0)
            }
        }
    }
}
