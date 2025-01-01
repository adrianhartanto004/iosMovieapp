import Foundation
import CoreData
import Combine

protocol FavouriteMoviesDao {
    func insert(movieDetail: MovieDetail) -> AnyPublisher<Void, Error>
    func fetchAllFavouriteMovies() -> AnyPublisher<[NowPlayingMovies], Error>
    func doesFavouriteMovieExist(movieId: Int) -> AnyPublisher<Bool, Error>
    func deleteFavouriteMovie(movieId: Int) -> AnyPublisher<Void, Error>
}

class FavouriteMoviesDaoImpl: FavouriteMoviesDao {
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func insert(movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.configureAsUpdateContext()
            context.perform {
                do {
                    guard let favouriteMoviesEntity = FavouriteMoviesEntity.insertNew(in: context) else { return }
                    favouriteMoviesEntity.id = Int32(movieDetail.id)
                    favouriteMoviesEntity.title = movieDetail.title
                    favouriteMoviesEntity.posterPath = movieDetail.posterPath
                    favouriteMoviesEntity.voteAverage = movieDetail.voteAverage ?? 0
                    favouriteMoviesEntity.voteCount = Int32(movieDetail.voteCount ?? 0)
                    favouriteMoviesEntity.releaseDate = movieDetail.releaseDate
                    favouriteMoviesEntity.addedAt = Date()
                    
                    if context.hasChanges == true {
                        try context.save()
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func fetchAllFavouriteMovies() -> AnyPublisher<[NowPlayingMovies], Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<FavouriteMoviesEntity> = FavouriteMoviesEntity.fetchRequest()
            request.fetchBatchSize = 10
            let sortDescriptor = NSSortDescriptor(key: "addedAt", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    let favouriteMoviesEntity = try context.fetch(request)               
                    let nowPlayingMovies = favouriteMoviesEntity.map { favouriteMovieEntity in
                        NowPlayingMovies(
                            id: Int(favouriteMovieEntity.id),
                            posterPath: favouriteMovieEntity.posterPath ?? "",
                            releaseDate: favouriteMovieEntity.releaseDate ?? "",
                            title: favouriteMovieEntity.title ?? "",
                            voteAverage: favouriteMovieEntity.voteAverage,
                            voteCount: Int(favouriteMovieEntity.voteCount)
                        )
                    }
                    promise(.success(nowPlayingMovies))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func doesFavouriteMovieExist(movieId: Int) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<FavouriteMoviesEntity> = FavouriteMoviesEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    if try context.fetch(request).first != nil {
                        promise(.success(true))
                    }
                    promise(.success(false))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteFavouriteMovie(movieId: Int) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<FavouriteMoviesEntity> = FavouriteMoviesEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    if let favouriteMoviesEntity = try context.fetch(request).first {
                        context.delete(favouriteMoviesEntity)
                    }
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
            
        }
        .eraseToAnyPublisher()
    }
}
