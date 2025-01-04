import SwiftUI
import SDWebImageSwiftUI
import SwiftUIIntrospect

struct NowPlayingMoviesListView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel = 
        ViewModelProvider.getInstance().provideNowPlayingMoviesListViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            nowPlayingMoviesView
        }
        .padding(.top, 60)
        .onAppear {
            viewModel.loadNowPlayingMovies()
            viewModel.fetchNowPlayingMovies()
        }
        .edgesIgnoringSafeArea([.all])
        .navigationBarBackButtonHidden()
    }
}

extension NowPlayingMoviesListView {
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: { 
                Image(systemName: "chevron.left")
            }
            Text("More Now Playing Movies")
                .padding(.leading, 16)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var nowPlayingMoviesView: some View {
        if viewModel.moviesError != nil {
            Button {
                viewModel.loadNowPlayingMovies()
                viewModel.fetchNowPlayingMovies()
            } label: {
                HStack {
                    Text("Retry Fetch Now Playing Movies")
                        .foregroundColor(Color.generalText)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.buttonBackground)
                }
                .cornerRadius(24)
            }
            .padding(16)
        } else {
            List {
                NowPlayingMoviesView(viewModel: viewModel)
            }
            .introspect(.list, on: .iOS(.v13, .v14, .v15)) { tableView in
                tableView.separatorStyle = .none
            }
            .introspect(.list, on: .iOS(.v16, .v17, .v18)) { collectionView in
                if #available(iOS 14.0, *) {
                    var config = UICollectionLayoutListConfiguration(appearance: .plain)
                    config.showsSeparators = false
                    let layout = UICollectionViewCompositionalLayout.list(using: config)
                    collectionView.collectionViewLayout = layout 
                }
            }
            .listStyle(.plain)
            .padding(.top, 16)
        }
    }
}
