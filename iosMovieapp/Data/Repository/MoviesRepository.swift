import Foundation
import Combine

protocol MoviesRepository {
    func fetchNowPlayingMovies() -> AnyPublisher<Void, Error>
    func getNowPlayingMovies() -> AnyPublisher<[NowPlayingMovies], Error>
}

class MoviesRepositoryImpl: MoviesRepository {
    let nowPlayingMoviesService: NowPlayingMoviesService
    let nowPlayingMoviesDao: NowPlayingMoviesDao
    
    init(
        nowPlayingMoviesService: NowPlayingMoviesService,
        nowPlayingMoviesDao: NowPlayingMoviesDao
    ) {
        self.nowPlayingMoviesService = nowPlayingMoviesService
        self.nowPlayingMoviesDao = nowPlayingMoviesDao
    }
    
    func fetchNowPlayingMovies() -> AnyPublisher<Void, Error> {
        var nowPlayingMovies: [NowPlayingMovies] = []
        return nowPlayingMoviesService
            .fetch()
            .flatMap { [weak self] movies -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MoviesRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                nowPlayingMovies = movies.nowPlayingMovies
                return self.nowPlayingMoviesDao.deleteAll()
            }
            .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Fail.init(
                        error: NSError(
                            domain: "MoviesRepository", code: 0, userInfo: ["message": "nil self"])
                    )
                    .eraseToAnyPublisher()
                }
                return self.nowPlayingMoviesDao.insertAll(nowPlayingMovies)
            }
            .eraseToAnyPublisher()
    }
    
    func getNowPlayingMovies() -> AnyPublisher<[NowPlayingMovies], Error> {
        return self.nowPlayingMoviesDao.fetch()
    }
}
