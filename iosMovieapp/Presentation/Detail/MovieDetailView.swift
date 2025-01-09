import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel =
        ViewModelProvider.getInstance().provideMovieDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    movieDetailView
                    movieDetailCastsView
                    movieDetailPhotosView
                    movieDetailAuthorReviewsView
                }
            }
            .padding(.top, 16)
        }
        .padding(.top, 60)
        .onAppear {
            viewModel.loadMovieDetail(movieId: movieId)
            viewModel.loadMovieCasts(movieId: movieId)
            viewModel.loadMoviePhotos(movieId: movieId)
            viewModel.loadAuthorReviews(movieId: movieId)
            
            viewModel.fetchMovieDetail(movieId: movieId)
            viewModel.fetchMovieCasts(movieId: movieId)
            viewModel.fetchMoviePhotos(movieId: movieId)
            viewModel.fetchAuthorReviews(movieId: movieId)
        }
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden()
    }
}

extension MovieDetailView {
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: { 
                Image(systemName: "chevron.left")
            }
            Text("Movie Detail")
                .padding(.leading, 16)
            Spacer()
            Button {
                if let movieDetail = viewModel.movieDetail {
                    viewModel.addOrRemoveFavouriteMovie(movieDetail: movieDetail)
                }
            } label: {
                if viewModel.isFavouriteMovie {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var movieDetailView: some View {
        if viewModel.movieDetail != nil {
            MovieDetailContentView(viewModel: viewModel)
                .padding(.horizontal, 16)
        } else if viewModel.isMovieDetailLoading || viewModel.isMovieDetailRefreshing {
            MovieDetailShimmerView()
                .padding(.horizontal, 16)
        } else if viewModel.movieDetailError != nil {
            Button {
                viewModel.loadMovieDetail(movieId: movieId)
                viewModel.fetchMovieDetail(movieId: movieId)
            } label: {
                HStack {
                    Text("Retry Fetch Movie Detail")
                        .foregroundColor(Color.generalText)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.buttonBackground)
                }
                .cornerRadius(24)
            }
            .padding(16)
        }
    }
    
    @ViewBuilder
    private var movieDetailCastsView: some View {
        Text("Cast")
            .fontWeight(.bold)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        if !viewModel.movieCasts.isEmpty {
            MovieDetailCastsView(viewModel: viewModel)
        } else if viewModel.isMovieCastsLoading || viewModel.isMovieCastsRefreshing {
            MovieDetailCastsShimmerView()
        } else if viewModel.movieCastsError != nil {
            Button {
                viewModel.loadMovieCasts(movieId: movieId)
                viewModel.fetchMovieCasts(movieId: movieId)
            } label: {
                HStack {
                    Text("Retry Fetch Movie Casts")
                        .foregroundColor(Color.generalText)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.buttonBackground)
                }
                .cornerRadius(24)
            }
            .padding(16)
        }
    }
    
    @ViewBuilder
    private var movieDetailPhotosView: some View {
        Text("Photo")
            .fontWeight(.bold)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        if !viewModel.moviePhotos.isEmpty {
            MovieDetailPhotosView(viewModel: viewModel)
        } else if viewModel.isMoviePhotosLoading || viewModel.isMoviePhotosRefreshing {
            MovieDetailPhotosShimmerView()
        } else if viewModel.moviePhotosError != nil {
            Button {
                viewModel.loadMoviePhotos(movieId: movieId)
                viewModel.fetchMoviePhotos(movieId: movieId)
            } label: {
                HStack {
                    Text("Retry Fetch Movie Photos")
                        .foregroundColor(Color.generalText)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.buttonBackground)
                }
                .cornerRadius(24)
            }
            .padding(16)
        }
    }
    
    @ViewBuilder
    private var movieDetailAuthorReviewsView: some View {
        Text("Reviews")
            .fontWeight(.bold)
            .padding(.bottom, 4)
            .padding(.horizontal, 16)
        Text("^[\(viewModel.authorReviews.count) review](inflect: true)")
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        if !viewModel.authorReviews.isEmpty {
            MovieDetailAuthorReviews(viewModel: viewModel)
                .padding(.horizontal, 16)
        } else if viewModel.isMovieAuthorReviewsLoading || viewModel.isMovieAuthorReviewsRefreshing {
            MovieDetailAuthorReviewsShimmerView()
                .padding(.horizontal, 16)
        } else if viewModel.movieAuthorReviewsError != nil {
            Button {
                viewModel.loadAuthorReviews(movieId: movieId)
                viewModel.fetchAuthorReviews(movieId: movieId)
            } label: {
                HStack {
                    Text("Retry Fetch Author Reviews")
                        .foregroundColor(Color.generalText)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.buttonBackground)
                }
                .cornerRadius(24)
            }
            .padding(16)
        }
    }
}

#Preview {
    MovieDetailView(movieId: 845781)
}
