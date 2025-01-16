import Foundation
import CoreData
import Combine

protocol MovieCastsDao {
    func insertAll(movieId: Int, _ items: [Cast]) -> AnyPublisher<Void, Error>
    func fetch(movieId: Int) -> AnyPublisher<[Cast], Error>
    func deleteMovieCredit(movieId: Int) -> AnyPublisher<Void, Error>
}

class MovieCastsDaoImpl: MovieCastsDao {
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func insertAll(movieId: Int, _ items: [Cast]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let context = self?.persistentStore.backgroundContext else { return promise(.failure(CoreDataError.contextNotAvailable)) }
            context.configureAsUpdateContext()
            context.perform {
                do {
                    guard let movieCreditListEntity = MovieCreditListEntity.insertNew(in: context) else { return }
                    movieCreditListEntity.id = Int32(movieId)
                    
                    items.enumerated().forEach { (castIndex, cast) in
                        guard let movieCastsEntity = MovieCastsEntity.insertNew(in: context)
                            else { return }
                        movieCastsEntity.index = Int32(castIndex)
                        movieCastsEntity.castId = Int32(cast.castId)
                        movieCastsEntity.name = cast.name
                        movieCastsEntity.profilePath = cast.profilePath
                        movieCastsEntity.castsRelation = movieCreditListEntity
                        movieCreditListEntity.addToCasts(movieCastsEntity)
                    }
                    
                    try context.saveIfNeeded()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func fetch(movieId: Int) -> AnyPublisher<[Cast], Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MovieCreditListEntity> = MovieCreditListEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            request.relationshipKeyPathsForPrefetching = ["casts"]
            guard let context = self?.persistentStore.backgroundContext else { return promise(.failure(CoreDataError.contextNotAvailable)) }
            context.perform {
                do {
                    guard let movieCreditListEntity = try context.fetch(request).first else { return promise(.failure(CoreDataError.dataNotAvailable)) }

                    let casts: [Cast] = (movieCreditListEntity.casts?.allObjects as? [MovieCastsEntity])?.sorted(by: { $0.index < $1.index} ).map  {
                        castEntity in
                        Cast(
                            castId: Int(castEntity.castId), 
                            name: castEntity.name, 
                            profilePath: castEntity.profilePath
                        )
                    } ?? []
                    
                    promise(.success(casts))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteMovieCredit(movieId: Int) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<MovieCreditListEntity> = MovieCreditListEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            guard let context = self?.persistentStore.backgroundContext else { return promise(.failure(CoreDataError.contextNotAvailable)) }
            context.perform {
                do {
                    if let movieCreditListEntity = try context.fetch(request).first {
                        context.delete(movieCreditListEntity)
                    }
                    try context.saveIfNeeded()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
