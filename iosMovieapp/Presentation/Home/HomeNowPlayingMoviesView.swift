import SwiftUI
import SDWebImageSwiftUI

struct HomeNowPlayingMoviesView: View {
    let movie: NowPlayingMovies
    
    var body: some View {
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
                        .foregroundColor(Color.generalText)
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.01f", movie.voteAverage))
                            .foregroundColor(Color.generalText)
                        Text("(\(movie.voteCount))")
                            .foregroundColor(Color.generalText)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.size.width / 2.3)
            .padding(.leading, 20)
        }
    }
}
