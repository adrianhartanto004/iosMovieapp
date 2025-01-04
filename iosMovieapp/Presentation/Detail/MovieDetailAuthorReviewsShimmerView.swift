import SwiftUI

struct MovieDetailAuthorReviewsShimmerView: View {
    var body: some View {
        Text(String(repeating: "Reviews", count: 1))
            .redacted(reason: .placeholder)
            .shimmering()
            .padding(.bottom, 12)
        Text(String(repeating: "12 reviews", count: 1))
            .redacted(reason: .placeholder)
            .shimmering()
            .padding(.bottom, 12)
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0..<5) { _ in
                    HStack(alignment: .top, spacing: 0) {
                        Rectangle()
                            .frame(width: 96, height: 96) 
                            .cornerRadius(16)
                            .clipShape(Circle())
                            .shimmering()
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .top, spacing: 0) {
                                Text(String(repeating: "Shimmer", count: 2))
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .padding(.trailing, 8)
                                Text(String(repeating: "8.0", count: 1))
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                            }
                            Text(String(repeating: "Shimmer", count: 1))
                                .redacted(reason: .placeholder)
                                .shimmering()
                            Text(String(repeating: "Shimmer", count: 12))
                                .lineLimit(3)
                                .redacted(reason: .placeholder)
                                .shimmering()
                        }
                        .padding(.leading, 16)
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .padding(.bottom, 16)
    }
}
