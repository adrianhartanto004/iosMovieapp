import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailAuthorReviews: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
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
