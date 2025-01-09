import Foundation
import Combine

protocol MovieDetailService {
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error>
    func fetchMovieCredits(movieId: Int) -> AnyPublisher<MovieCreditList, Error>
    func fetchMoviePhotos(movieId: Int) -> AnyPublisher<MoviePhotoList, Error>
    func fetchAuthorReviews(movieId: Int) -> AnyPublisher<AuthorReviewList, Error>
}

class MovieDetailServiceImpl: NetworkClientManager<HttpRequest>, MovieDetailService {
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        self.request(
            request: HttpRequest(request: MovieDetailRequest(movieId: movieId)),
            scheduler: DispatchQueue.main,
            responseObject: MovieDetail.self
        )
    }
    
    func fetchMovieCredits(movieId: Int) -> AnyPublisher<MovieCreditList, Error> {
        self.request(
            request: HttpRequest(request: MovieCreditsRequest(movieId: movieId)),
            scheduler: DispatchQueue.main,
            responseObject: MovieCreditList.self
        )
    }
    
    func fetchMoviePhotos(movieId: Int) -> AnyPublisher<MoviePhotoList, Error> {
        self.request(
            request: HttpRequest(request: MoviePhotosRequest(movieId: movieId)),
            scheduler: DispatchQueue.main,
            responseObject: MoviePhotoList.self
        )
    }
    
    func fetchAuthorReviews(movieId: Int) -> AnyPublisher<AuthorReviewList, Error> {
        self.request(
            request: HttpRequest(request: AuthorReviewsRequest(movieId: movieId)),
            scheduler: DispatchQueue.main,
            responseObject: AuthorReviewList.self
        )
    }
}
