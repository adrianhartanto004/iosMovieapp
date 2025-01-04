import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailCastsView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        Text("Cast")
            .fontWeight(.bold)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.movieCasts, id: \.castId) { cast in
                    VStack(alignment: .center, spacing: 0) {
                        WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(cast.profilePath ?? "")"))
                            .resizable()
                            .placeholder { 
                                Rectangle().foregroundColor(.gray)
                                    .shimmering()
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
                    .padding(.leading, 16)
                    .padding(.trailing, cast.castId == viewModel.movieCasts.last!.castId ? 16 : 0)
                }
            }
        }
        .padding(.bottom, 16)
    }
}
