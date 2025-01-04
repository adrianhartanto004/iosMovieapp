import SwiftUI

struct MovieDetailPhotosShimmerView: View {
    var body: some View {
        Text(String(repeating: "Shimmer", count: 1))
            .redacted(reason: .placeholder)
            .shimmering()
            .padding(.bottom, 12)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<6) { _ in
                    Rectangle().foregroundColor(.gray)
                        .frame(width: UIScreen.main.bounds.size.width / 1.6, height: UIScreen.main.bounds.size.height / 6)
                        .cornerRadius(16)
                        .shimmering()
                        .padding(.bottom, 6)
                        .padding(.trailing, 16)
                }
            }
        }
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }
}
