import SwiftUI

struct MovieDetailCastsShimmerView: View {
    var body: some View {
        Text(String(repeating: "Shimmer", count: 1))
            .redacted(reason: .placeholder)
            .shimmering()
            .padding(.bottom, 12)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<6) { _ in
                    VStack(alignment: .center, spacing: 0) {
                        Rectangle().foregroundColor(.gray)
                            .frame(width: 96, height: 96) 
                            .clipShape(Circle())
                            .shimmering()
                            .padding(.bottom, 6)
                        Text(String(repeating: "Shimmer", count: 1))
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                    .frame(width: 96) 
                    .padding(.trailing, 16)
                }
            }
        }
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }
}
