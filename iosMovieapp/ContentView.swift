import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                FavouriteMoviesView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favourite")
                    }
            }
        }
    }
}
