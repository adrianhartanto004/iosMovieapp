import Combine
import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel =
        ViewModelProvider.getInstance().provideHomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("NOW PLAYING")
                        Spacer()
                        NavigationLink { 
                            NowPlayingMoviesListView()
                        } label: { 
                            Text("Show all")
                        }
                    }
                    .padding(.horizontal, 20)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            if viewModel.isNowPlayingMoviesLoading {
                                ForEach(0..<5) { _ in
                                    VStack(alignment: .leading, spacing: 0) {
                                        Rectangle()
                                            .frame(width: UIScreen.main.bounds.size.width / 2.3, height: UIScreen.main.bounds.size.height / 3) 
                                            .cornerRadius(16)
                                            .shimmering()
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(String(repeating: "Shimmer", count: 2))
                                                .redacted(reason: .placeholder)
                                                .shimmering()
                                                .padding(.top, 10)
                                                .lineLimit(4)
                                                .multilineTextAlignment(.leading)
                                            HStack {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                                Text(String(repeating: "Shimmering", count: 1))
                                                    .redacted(reason: .placeholder)
                                                    .shimmering()
                                            }
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.size.width / 2.3)
                                    .padding(.leading, 20)
                                }
                            } else {
                                ForEach(viewModel.nowPlayingMovies, id: \.id) { movie in
                                    NavigationLink { 
                                        MovieDetailView(movieId: movie.id)
                                    } label: { 
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
                                            VStack(alignment: .leading, spacing: 0) {
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
                                            }
                                        }
                                        .frame(width: UIScreen.main.bounds.size.width / 2.3)
                                        .padding(.leading, 20)
                                    }
                                }
                            }
                        }
                        .padding(.top, 14)
                    }
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
        //        .background(Color.homeBackground)
        .edgesIgnoringSafeArea([.all])
    }
}

#Preview {
    HomeView()
}
