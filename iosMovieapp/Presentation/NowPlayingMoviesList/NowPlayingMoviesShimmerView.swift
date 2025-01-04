import SwiftUI

struct NowPlayingMoviesShimmerView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle().foregroundColor(.gray)
                    .shimmering()
                    .frame(width: UIScreen.main.bounds.size.width / 2.3, height: UIScreen.main.bounds.size.height / 3) 
                    .cornerRadius(16)
            }
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Text(String(repeating: "Shimmer", count: 2))
                    .redacted(reason: .placeholder)
                    .shimmering()
                    .padding(.top, 10)
                    .multilineTextAlignment(.leading)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(repeating: "10.0", count: 1))
                        .redacted(reason: .placeholder)
                        .shimmering()
                    Text(String(repeating: "Shimmer", count: 1))
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
                Spacer()
            }
        }
    }
}
