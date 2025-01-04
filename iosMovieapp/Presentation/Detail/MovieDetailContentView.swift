import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailContentView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        HStack {
            WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(viewModel.movieDetail?.posterPath ?? "")"))
                .resizable()
                .placeholder { 
                    Rectangle().foregroundColor(.gray)
                        .shimmering()
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
