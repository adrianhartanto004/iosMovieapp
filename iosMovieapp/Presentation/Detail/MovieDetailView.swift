import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    let movieId: Int
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel =
        ViewModelProvider.getInstance().provideMovieDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(viewModel.movieDetail?.posterPath ?? "")"))
                            .resizable()
                            .placeholder { 
                                Rectangle().foregroundColor(.gray)
                            }
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.size.width / 2.3, height: UIScreen.main.bounds.size.height / 3) 
                            .cornerRadius(16)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(viewModel.movieDetail?.title ?? "")
                                .padding(.bottom, 8)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.01f", viewModel.movieDetail?.voteAverage ?? 0))
                                Text("( \(viewModel.movieDetail?.voteCount ?? 0) )")
                            }
                            .padding(.bottom, 8)
                            Text((viewModel.movieDetail?.genres?.map{ genre in
                                genre.name
                            }.joined(separator: ", ")) ?? "")
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.bottom, 16)
                    Text("Release date: \(viewModel.movieDetail?.releaseDate ?? "")")
                        .padding(.bottom, 4)
                    Text("Original language: \(viewModel.movieDetail?.originalLanguage ?? "")")
                        .padding(.bottom, 4)
                    Text("Production company: \(getProductionCompaniesText(productionCompanies: viewModel.movieDetail?.productionCompanies ?? []))")
                        .padding(.bottom, 4)
                    Text("Production countries: \(getProductionCountriesText(productionCountries: viewModel.movieDetail?.productionCountries ?? []))")
                        .padding(.bottom, 4)
                    Text("Budget: \(viewModel.movieDetail?.budget ?? 0)")
                        .padding(.bottom, 4)
                    Text("Revenue: \(viewModel.movieDetail?.revenue ?? 0)")
                        .padding(.bottom, 16)
                    Text("Overview")
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    Text("\(viewModel.movieDetail?.overview ?? "")")
                        .padding(.bottom, 16)
                    Text("Cast")
                        .fontWeight(.bold)
                        .padding(.bottom, 12)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(viewModel.movieCasts, id: \.castId) { cast in
                                VStack(alignment: .center, spacing: 0) {
                                    WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(cast.profilePath ?? "")"))
                                        .resizable()
                                        .placeholder { 
                                            Rectangle().foregroundColor(.gray)
                                        }
                                        .scaledToFill()
                                        .frame(width: 96, height: 96) 
                                        .clipShape(Circle())
                                        .padding(.bottom, 6)
                                    Text(cast.name ?? "")
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 96) 
                                .padding(.trailing, 16)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                    Text("Photo")
                        .fontWeight(.bold)
                        .padding(.bottom, 12)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(viewModel.moviePhotos, id: \.self) { photo in
                                WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(photo.filePath ?? "")"))
                                    .resizable()
                                    .placeholder { 
                                        Rectangle().foregroundColor(.gray)
                                    }
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.size.width / 1.6, height: UIScreen.main.bounds.size.height / 6)
                                    .cornerRadius(16)
                                    .padding(.bottom, 6)
                                    .padding(.trailing, 16)
                            }
                        }
                    }
                    .padding(.bottom, 16)                    
                    Text("Reviews")
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    Text("^[\(viewModel.authorReviews.count) review](inflect: true)")
                        .padding(.bottom, 16)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.authorReviews, id: \.id) { authorReview in
                                HStack(alignment: .top, spacing: 0) {
                                    WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(authorReview.authorDetails?.avatarPath ?? "")"))
                                        .resizable()
                                        .placeholder(Image(systemName: "person.crop.circle.fill"))
                                        .scaledToFill()
                                        .frame(width: 96, height: 96) 
                                        .cornerRadius(16)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .top, spacing: 0) {
                                            Text(authorReview.author ?? "")
                                            Spacer()
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .padding(.trailing, 8)
                                            Text(String(format: "%.01f", authorReview.authorDetails?.rating ?? 0))
                                        }
                                        Text("\(authorReview.updatedAt?.prefix(10) ?? "")")
                                        Text(authorReview.content ?? "")
                                            .lineLimit(3)
                                    }
                                    .padding(.leading, 16)
                                }
                                .padding(.bottom, 16)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.top, 16)
        }
        .padding(.top, 60)
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.loadMovieDetail(movieId: movieId)
            viewModel.loadMovieCasts(movieId: movieId)
            viewModel.loadMoviePhotos(movieId: movieId)
            viewModel.loadAuthorReviews(movieId: movieId)
            
            viewModel.fetchMovieDetail(movieId: movieId)
            viewModel.fetchMovieCasts(movieId: movieId)
            viewModel.fetchMoviePhotos(movieId: movieId)
//            viewModel.fetchRecommendedMovies(movieId: movieId)
            viewModel.fetchAuthorReviews(movieId: movieId)
        }
        //        .background(Color.homeBackground)
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden()
    }
    
    private func getProductionCompaniesText(productionCompanies: [ProductionCompany]) -> String {
        return productionCompanies.map { productionCompany in
            productionCompany.name ?? ""
        }.joined(separator: ", ")
    }
    
    private func getProductionCountriesText(productionCountries: [ProductionCountry]) -> String {
        return productionCountries.map { productionCountry in
            productionCountry.name ?? ""
        }.joined(separator: ", ")
    }
}

#Preview {
    MovieDetailView(movieId: 845781)
}
