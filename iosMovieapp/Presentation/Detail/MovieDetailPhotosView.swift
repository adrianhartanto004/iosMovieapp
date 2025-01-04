import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailPhotosView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        Text("Photo")
            .fontWeight(.bold)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.moviePhotos, id: \.self) { photo in
                    WebImage(url: URL.initURL("\(Constants.EndpointUrls.baseImage)\(photo.filePath ?? "")"))
                        .resizable()
                        .placeholder { 
                            Rectangle().foregroundColor(.gray)
                                .shimmering()
                        }
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width / 1.6, height: UIScreen.main.bounds.size.height / 6)
                        .cornerRadius(16)
                        .padding(.bottom, 6)
                        .padding(.leading, 16)
                        .padding(.trailing, photo == viewModel.moviePhotos.last! ? 16 : 0)
                }
            }
        }
        .padding(.bottom, 16)
    }
}
