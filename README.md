# iosMovieapp
Steps to run the project: 
- Create a file Key.swift inside ***iosMovieapp/Data*** folder and add your API key from [TMDB](https://developer.themoviedb.org/)
```
struct Key {
    static let API_KEY = "<Your API KEY>"
}
```

<img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20key.png">

- Run the project

## Features
  * Minimum iOS 13.0 deployment
  * Pagination
  * Shimmering view
  * Add movies to favourite
  * Fetch and save to Database (works in offline mode)
  * Unit tests

## Tech-Stacks
  * SwiftUI
  * Combine
  * URLSession
  * Coredata
  * ViewModel
  * Dependency Injection
  * Clean + MVVM Architecture
## Libraries used
  * [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImage) (v 2.2.7) for ImageLoading on iOS 13.0
  * [SwiftUI Introspect](https://github.com/siteline/swiftui-introspect) . Current is only being used for hiding list separators 
  * [PublishedObject](https://github.com/Amzd/PublishedObject) to use StateObject in iOS 13.0

# Demo (can be found in demo folder)
## Screenshots

| HomeView |
| --- |
| <img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20homeview.png" style="width:50%; height:auto;"> |

| MovieDetail Loading | MovieDetail loaded |
| --- | --- |
| <img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20moviedetail%20shimmering%201.png"> | <img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20moviedetail.png"> |

| MovieDetail Loading (cont.) | MovieDetail loaded (cont.) |
| --- | --- |
| <img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20cast%20shimmering.png"> | <img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20moviedetail%20cast.png">

| NowPlayingMovies load more | 
| --- |
| <img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20nowplaying%20movies.png" style="width:50%; height:auto;"> |

| FavouriteMovie added | 
| --- |
| <img src="https://github.com/adrianhartanto004/iosMovieapp/blob/dev/demo/iosMovieapp%20favouritemovielist.png" style="width:50%; height:auto;"> |

## Videos

<video src="https://github.com/user-attachments/assets/777d4401-3df6-4d97-8083-8f4ca881f829"/>
