import Foundation
import CoreData
import Combine

protocol NowPlayingMoviesDao {
    func insertAll(_ items: [NowPlayingMovies]) -> AnyPublisher<Void, Error>
    func fetch() -> AnyPublisher<[NowPlayingMovies], Error>
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
                    items.enumerated().forEach { (index, item) in
                        item.store(in: context, id: Int16(index))
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
    
    func fetch() -> AnyPublisher<[NowPlayingMovies], Error> {
        return Future { [weak self] promise in
            let request: NSFetchRequest<NowPlayingMoviesEntity> = NowPlayingMoviesEntity.fetchRequest()
            request.fetchBatchSize = 10
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            guard let context = self?.persistentStore.backgroundContext else { return }
            context.perform {
                do {
                    let managedObjects = try context.fetch(request)
                    let newEpisodes = managedObjects.map { newEpisodesEntity in
                        newEpisodesEntity.toNowPlayingMovies()
                    }
                    promise(.success(newEpisodes))
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
