import Foundation
import CoreData
import Combine

protocol NowPlayingMoviesDao {
    func insertAll(_ items: [NowPlayingMovies]) -> AnyPublisher<Void, Error>
    func fetch(limit: Int?) -> AnyPublisher<[NowPlayingMovies], Error>
    func deleteAll() -> AnyPublisher<Void, Error>
}

class NowPlayingMoviesDaoImpl: NowPlayingMoviesDao {
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func insertAll(_ items: [NowPlayingMovies]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.configureAsUpdateContext()
            context.perform {
                do {
                    items.forEach { item in
                        item.store(in: context, addedAt: Date())
                    }
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
    
    func fetch(limit: Int? = nil) -> AnyPublisher<[NowPlayingMovies], Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<NowPlayingMoviesEntity> = NowPlayingMoviesEntity.fetchRequest()
            request.fetchBatchSize = 10
            if let limit = limit {
                request.fetchLimit = limit
            }
            let sortDescriptor = NSSortDescriptor(key: "addedAt", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    let managedObjects = try context.fetch(request)
                    let nowPlayingMoviesEntity = managedObjects.map { nowPlayingMovieEntity in
                        nowPlayingMovieEntity.toNowPlayingMovies()
                    }
                    promise(.success(nowPlayingMoviesEntity))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DBName.nowPlayingMoviesEntity)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            batchDeleteRequest.resultType = .resultTypeCount
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    try context.execute(batchDeleteRequest)
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
