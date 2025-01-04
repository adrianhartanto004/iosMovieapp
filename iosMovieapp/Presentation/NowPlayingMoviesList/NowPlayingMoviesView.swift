import SwiftUI
import SDWebImageSwiftUI

struct NowPlayingMoviesView: View {
    @ObservedObject var viewModel: NowPlayingMoviesListViewModel
        
    var body: some View {
        if viewModel.isNowPlayingMoviesLoading {
            ForEach(0..<5) { _ in
                NowPlayingMoviesShimmerView()
            }
        } else {
            NowPlayingMoviesItemView(viewModel: viewModel)
        }
    }
}
