import SwiftUI

struct MovieDetailShimmerView: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width / 2.3, height: UIScreen.main.bounds.size.height / 3) 
                .cornerRadius(16)
                .shimmering()
            VStack(alignment: .leading, spacing: 0) {
                Text(String(repeating: "Shimmer", count: 3))
                    .redacted(reason: .placeholder)
                    .shimmering()
                    .padding(.bottom, 8)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(repeating: "Shimmer", count: 2))
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
                .padding(.bottom, 8)
                Text(String(repeating: "Shimmer", count: 2))
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
            .padding(.leading, 8)
        }
        .padding(.bottom, 16)
        Text(String(repeating: "Shimmer", count: 4))
            .redacted(reason: .placeholder)
            .shimmering()
            .padding(.bottom, 4)
        Text(String(repeating: "Shimmer", count: 2))
            .redacted(reason: .placeholder)
            .shimmering()
        Text(String(repeating: "Shimmer", count: 3))
            .redacted(reason: .placeholder)
            .shimmering()
        Text(String(repeating: "Shimmer", count: 3))
            .redacted(reason: .placeholder)
            .shimmering()
            .padding(.bottom, 4)
        Text(String(repeating: "Shimmer", count: 2))
            .redacted(reason: .placeholder)
            .shimmering()
        Text(String(repeating: "Shimmer", count: 2))
            .redacted(reason: .placeholder)
            .shimmering()
        Text(String(repeating: "Shimmer", count: 1))
            .redacted(reason: .placeholder)
            .shimmering()
        Text(String(repeating: "Shimmer", count: 3))
            .redacted(reason: .placeholder)
            .shimmering()
            .padding(.bottom, 16)
    }
}
