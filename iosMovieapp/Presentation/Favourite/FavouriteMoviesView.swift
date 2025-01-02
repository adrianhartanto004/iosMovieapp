import SwiftUI
import SDWebImageSwiftUI

struct FavouriteMoviesView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel =
        ViewModelProvider.getInstance().provideFavouriteMoviesViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
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
                            .padding(.bottom, 16)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 16)
        }
        .padding(.top, 60)
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.loadFavouriteMovies()
        }
        //        .background(Color.homeBackground)
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden()
    }
}
