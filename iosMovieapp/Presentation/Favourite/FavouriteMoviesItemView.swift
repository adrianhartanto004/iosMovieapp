import SwiftUI
import SDWebImageSwiftUI

struct FavouriteMoviesItemView: View {
    let nowPlayingMovies: NowPlayingMovies
    
    var body: some View {
        NavigationLink { 
            MovieDetailView(movieId: nowPlayingMovies.id)
        } label: {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(nowPlayingMovies.posterPath)"))
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
                    Text(nowPlayingMovies.title)
                        .foregroundColor(Color.generalText)
                        .padding(.top, 10)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.01f", nowPlayingMovies.voteAverage))
                            .foregroundColor(Color.generalText)
                        Text("(\(nowPlayingMovies.voteCount))")
                            .foregroundColor(Color.generalText)
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 16)
        }
    }
}
