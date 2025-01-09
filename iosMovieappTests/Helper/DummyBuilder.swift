import Foundation

@testable import iosMovieapp

func createNowPlayingMovies(
    movieId: Int,
    posterPath: String = randomString(2),
    releaseDate: String = randomString(2),
    title: String = randomString(2),
    voteAverage: Double = Double.random(in: 1...100),
    voteCount: Int = Int.random(in: 1...100)
) -> NowPlayingMovies {
    return NowPlayingMovies(
        id: movieId,
        posterPath: posterPath,
        releaseDate: releaseDate,
        title: title,
        voteAverage: voteAverage,
        voteCount: voteCount
    )
}

func createNowPlayingMoviesList() -> NowPlayingMoviesList {
    NowPlayingMoviesList(
        page: Int.random(in: 1...100),
        nowPlayingMovies: [
            createNowPlayingMovies(movieId: Int.random(in: 1...100)), 
            createNowPlayingMovies(movieId: Int.random(in: 1...100))
        ],
        totalPages: Int.random(in: 1...100),
        totalResults: Int.random(in: 1...100)
    )
}

func createMovieDetail(movieId: Int) -> MovieDetail {
    return MovieDetail(
        budget: Int.random(in: 1...100), 
        genres: [createGenres(), createGenres()], 
        id: movieId, 
        originalLanguage: randomString(2), 
        overview: randomString(2), 
        posterPath: randomString(2), 
        productionCompanies: [createProductionCompany(), createProductionCompany()], 
        productionCountries: [createProductionCountry(), createProductionCountry()], 
        releaseDate: randomString(2), 
        revenue: Int.random(in: 1...100),  
        title: randomString(2),
        voteAverage: Double.random(in: 1...100),
        voteCount: Int.random(in: 1...100)
    )
}

func createGenres() -> Genre {
    return Genre(
        id: Int.random(in: 1...100), 
        name: randomString(2)
    )
}

func createProductionCompany() -> ProductionCompany {
    return ProductionCompany(
        id: Int.random(in: 1...100), 
        name: randomString(2),
        originCountry: randomString(2)
    )
}

func createProductionCountry() -> ProductionCountry {
    return ProductionCountry(
        isoDate: randomString(2), 
        name: randomString(2)
    )
}

func createMovieCreditList() -> MovieCreditList {
    return MovieCreditList(
        id: Int.random(in: 1...100),
        cast: [createCast(), createCast()], 
        crew: [createCrew(), createCrew()]
    )
}

func createCrew() -> Crew {
    return Crew(
        adult: Bool.random(), 
        gender: Int.random(in: 1...2), 
        id: Int.random(in: 1...100),
        knownForDepartment: randomString(2), 
        name: randomString(2), 
        originalName: randomString(2), 
        popularity: Double.random(in: 1...2), 
        profilePath: randomString(2), 
        creditId: randomString(2), 
        department: randomString(2), 
        job: randomString(2)
    )
}

func createCast() -> Cast {
    return Cast(
        castId: Int.random(in: 1...100), 
        name: randomString(2), 
        profilePath: randomString(2)
    )
}

func createMoviePhotoList() -> MoviePhotoList {
    return MoviePhotoList(photos: [createPhotos(), createPhotos(), createPhotos()])
}

func createPhotos() -> Photo {
    return Photo(filePath: randomString(2))
}

func createAuthorReviewList() -> AuthorReviewList {
    return AuthorReviewList(
        id: Int.random(in: 1...100), 
        page: Int.random(in: 1...100),
        authorReviews: [createAuthorReview(), createAuthorReview(), createAuthorReview()], 
        totalPages: Int.random(in: 1...100),
        totalResults: Int.random(in: 1...100)
    )
}

func createAuthorReview() -> AuthorReview {
    return AuthorReview(
        author: randomString(2), 
        authorDetails: createAuthorDetails(), 
        content: randomString(2), 
        id: randomString(2), 
        updatedAt: randomString(2)
    )
}

func createAuthorDetails() -> AuthorDetails {
    return AuthorDetails(avatarPath: randomString(2), rating: Double.random(in: 1...100))
}
