import SwiftUI

struct FavouriteMoviesView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel =
        ViewModelProvider.getInstance().provideFavouriteMoviesViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.nowPlayingMovies.isEmpty {
                Text("Add movies to favourite")
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        favouriteMoviesView
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 16)
            }
        }
        .padding(.top, 60)
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.loadFavouriteMovies()
        }
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden()
    }
}

extension FavouriteMoviesView {
    @ViewBuilder
    private var favouriteMoviesView: some View {
        if viewModel.favouriteMoviesError != nil {
            Button {
                viewModel.loadFavouriteMovies()
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
            if viewModel.isLoading {
                ForEach(0..<5) { _ in
                    FavouriteMoviesShimmerView()
                }
            } else {
                ForEach(viewModel.nowPlayingMovies, id: \.id) { movie in
                    FavouriteMoviesItemView(nowPlayingMovies: movie)
                }
            }
        }
    }
}
