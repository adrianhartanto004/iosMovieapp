import SwiftUI

struct HomeNowPlayingMoviesShimmerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width / 2.3, height: UIScreen.main.bounds.size.height / 3) 
                .cornerRadius(16)
                .shimmering()
            VStack(alignment: .leading, spacing: 0) {
                Text(String(repeating: "Shimmer", count: 2))
                    .redacted(reason: .placeholder)
                    .shimmering()
                    .padding(.top, 10)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(repeating: "Shimmering", count: 1))
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.size.width / 2.3)
        .padding(.leading, 20)
    }
}
