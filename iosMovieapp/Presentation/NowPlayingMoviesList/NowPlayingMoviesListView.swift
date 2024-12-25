import SwiftUI
import SDWebImageSwiftUI

struct NowPlayingMoviesListView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel =
        ViewModelProvider.getInstance().provideHomeViewModel()
    
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
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.nowPlayingMovies, id: \.id) { movie in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 0) {
                                WebImage(url: URL.initURL("\(Constants.EndpointUrls.BaseImage)\(movie.posterPath)"))
                                    .resizable()
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
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 16)
        }
        .padding(.top, 60)
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.loadNewEpisodesMedia()
            viewModel.fetchNewEpisodes()
        }
        //        .background(Color.homeBackground)
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden()
    }
}
